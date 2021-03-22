{*
 * Copyright (C) 2017-2018 thirty bees
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.md
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to contact@thirtybees.com so we can send you a copy immediately.
 *
 * @author    thirty bees <contact@thirtybees.com>
 * @copyright 2017-2018 thirty bees
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}
<script type="text/javascript">
  (function () {
    {* If dev mode, enable Vue dev mode as well *}
    {if $smarty.const._PS_MODE_DEV_}Vue.config.devtools = true;{/if}

    var ajaxAttempts = window.elasticMaxRetries;

    function addClass(el, className) {
      if (el.classList) {
        el.classList.add(className);
      } else {
        el.className += ' ' + className;
      }
    }

    function removeClass(el, className) {
      if (el.classList) {
        el.classList.remove(className);
      } else {
        el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
      }
    }

    function indexProducts(self, callback) {
      var request = new XMLHttpRequest();
       // To prevent XMLHttpRequest to be cached, we use a random number each time
      var rand = Math.random();
      request.open('GET', window.elasticAjaxUrl + '&ajax=1&action=indexRemaining&rand=' + rand, true);

      request.onreadystatechange = function() {
        if (this.readyState === 4) {
          var response;
          try {
            response = JSON.parse(this.responseText);
          } catch (e) {
            response = null;
          }

          if (this.status >= 200 && this.status < 400) {
            // Success!
            if (typeof response !== 'undefined'
              && response
              && typeof response.indexed !== 'undefined'
              && typeof response.total !== 'undefined'
            ) {
              self.$store.commit('setIndexingStatus', {
                indexed: response.indexed,
                total: response.total
              });
            } else {
              swal({
                title: '{l s='Error!' mod='elasticsearch' js=1}',
                text: '{l s='Unable to connect with the Elasticsearch server. Has the connection been configured?' mod='elasticsearch' js=1}',
                icon: 'error'
              });

              if (typeof callback === 'function') {
                callback('success', response, this);
              }
            }
          } else {
            // Error :(
            if (typeof callback === 'function') {
              callback('error', response, this);
            }
          }

          // Finally
          if ((parseInt(this.status, 10) !== 200 && ajaxAttempts > 0)
            || (!self.$store.state.cancelingIndexing && typeof response !== 'undefined' && response && response.indexed !== response.total)
          ) {
            if (this.status < 200 || this.status >= 400) {
              // Decrement if failure...
              ajaxAttempts -= 1;
            } else {
              // ...reset otherwise
              ajaxAttempts = window.elasticMaxRetries;
            }

            indexProducts(self);
          } else {
            if (ajaxAttempts <= 0) {
              swal({
                title: '{l s='Error!' mod='elasticsearch' js=1}',
                text: '{l s='Error while contacting the webserver. Please check the server logs for errors and correct them if necessary.' mod='elasticsearch' js=1}',
                icon: 'error'
              });
            }

            self.$store.commit('setIndexing', false);
            self.$store.commit('setCancelingIndexing', false);
          }

          if (typeof callback === 'function') {
            callback('complete', response, this);
          }
        }
      };

      request.send();
      request = null;
    }

    function eraseIndex(self, callback) {
      self.$store.commit('setSaving', true);
      var request = new XMLHttpRequest();
      request.open('GET', window.elasticAjaxUrl + '&ajax=1&action=eraseIndex', true);

      request.onreadystatechange = function() {
        if (this.readyState === 4) {
          var response;
          try {
            response = JSON.parse(this.responseText);
          } catch (e) {
            response = null;
          }

          if (this.status >= 200 && this.status < 400) {
            // Success!
            if (typeof response !== 'undefined'
              && response
              && typeof response.indexed !== 'undefined'
              && typeof response.total !== 'undefined'
            ) {
              self.$store.commit('setIndexingStatus', {
                indexed: response.indexed,
                total: response.total
              });
            }

            if (typeof callback === 'function') {
              callback('success', response, this);
            }
          } else {
            // Error :(
            if (typeof callback === 'function') {
              callback('error', response, this);
            }
          }

          // Finally
          self.$store.commit('setSaving', false);
          self.$store.commit('setConfigUpdated', false);

          if (typeof callback === 'function') {
            callback('complete', response, this);
          }
        }
      };

      request.send(JSON.stringify(self.$store.state.config));
      request = null;
    }

    new Vue({
      created: function () {
        var self = this;
        var request = new XMLHttpRequest();
        request.open('GET', window.elasticAjaxUrl + '&ajax=1&action=getElasticsearchVersion', true);

        request.onreadystatechange = function() {
          if (this.readyState === 4) {
            var response;
            try {
              response = JSON.parse(this.responseText);
            } catch (e) {
              response = null;
            }

            if (this.status >= 200 && this.status < 400) {
              // Success!
              if (response && response.version) {
                self.$store.commit('setElasticsearchVersion', response.version);
              }
            } else {
              // Error :(
            }

            // Finally
          }
        };

        request.send();
        request = null;
      },
      delimiters: ['%%', '%%'],
      el: '#es-module-page',
      store: window.config,
      components: {
        Toggle: VueOptionSwitch,
        LangTextInput: VueLangTextInput,
        TextInput: VueTextInput,
        NumberInput: VueNumberInput,
        ServerList: VueOptionServerList,
        MetaBadge: VueMetaBadge,
        IndexMetaList: VueIndexMetaList,
        SearchMetaList: VueSearchMetaList,
        FilterMetaList: VueFilterMetaList,
        QueryJson: VueQueryJson,
        TaxSelector: VueTaxSelector
      },
      computed: {
        currentTab: function () {
          return this.$store.state.tab;
        },
        tabGroups: function () {
          return {$tabGroups|json_encode};
        },
        canSubmit: function () {
          return this.$store.state.configChanged && !this.loading;
        },
        productsIndexed: function () {
          return this.$store.state.status.indexed;
        },
        productsToIndex: function () {
          return this.$store.state.status.total;
        },
        elasticsearchVersion: function () {
          return this.$store.state.elasticsearchVersion;
        },
        indexing: function () {
          return this.$store.state.indexing;
        },
        cancelingIndexing: function () {
          return this.$store.state.cancelingIndexing;
        },
        saving: function () {
          return this.$store.state.saving;
        },
        configUpdated: function () {
          return this.$store.state.configUpdated;
        }
      },
      data: function data() {
        return {
          totalProducts: {$totalProducts|intval},
          languages: {$languages|json_encode}
        };
      },
      methods: {
        setTab: function (tabKey) {
          this.$store.commit('setTab', tabKey);
        },
        setLoading: function (loading) {
          _.forEach(document.querySelectorAll('.ajax-save-btn'), function (elem, index) {
            var i = elem.querySelector('i');
            if (loading) {
              removeClass(i, 'process-icon-save');
              addClass(i, 'process-icon-loading');
              elem.setAttribute('disabled', 'disabled');
            } else {
              removeClass(i, 'process-icon-loading');
              elem.removeAttribute('disabled');
            }
          });
        },
        startFullIndexing: function () {
          var self = this;

          eraseIndex(self, function (status) {
            self.$store.commit('setSaving', false);
            if (status === 'success') {
              self.startIndexing(self);
            }
          });
        },
        startIndexing: function () {
          this.$store.commit('setIndexing', true);

          // Reset the amount of ajax attempts
          ajaxAttempts = window.elasticMaxRetries;
          indexProducts(this);
        },
        cancelIndexing: function () {
          this.$store.commit('setCancelingIndexing', true);
        },
        eraseIndex: function () {
          eraseIndex(this);
        },
        submitSettings: function (event) {
          if (this.$store.state.saving) {
            return;
          }

          this.$store.commit('setSaving', true);

          var self = this;

          var request = new XMLHttpRequest();
          request.open('POST', window.elasticAjaxUrl + '&ajax=1&action=saveSettings', true);
          request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');

          request.onreadystatechange = function() {
            if (this.readyState === 4) {
              if (this.status >= 200 && this.status < 400) {
                // Success!
                self.$store.commit('setInitialConfig', JSON.stringify(self.$store.state.config));
                window.showSuccessMessage('{l s='Settings have been successfully updated' mod='elasticsearch' js=1}');
              } else {
                // Error :(
              }

              // Finally
              self.$store.commit('setSaving', false);
              self.$store.commit('setConfigUpdated', true);
            }
          };

          request.send(JSON.stringify(self.$store.state.config));
          request = null;
        }
      }
    })
  }());
</script>
