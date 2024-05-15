{*
 * Copyright (C) 2017-2024 thirty bees
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.md
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to contact@thirtybees.com so we can send you a copy immediately.
 *
 * @author    thirty bees <contact@thirtybees.com>
 * @copyright 2017-2024 thirty bees
 * @license   https://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}
{* Include dependencies *}
{capture name="resultsTemplate"}{include file=ElasticSearch::tpl('front/search.tpl')}{/capture}
{include file=ElasticSearch::tpl('hook/vue/results/product-count.vue.tpl')}
{include file=ElasticSearch::tpl('hook/vue/results/show-all.vue.tpl')}
{include file=ElasticSearch::tpl('hook/vue/results/pagination.vue.tpl')}
{include file=ElasticSearch::tpl('hook/vue/results/product-list-item.vue.tpl')}

{* Template file *}
{capture name="template"}{include file=ElasticSearch::tpl('hook/vue/results/product-section.html.tpl')}{/capture}
<script type="text/javascript">
  (function () {
    function ready(fn) {
      if (document.readyState !== 'loading') {
        fn();
      } else if (document.addEventListener) {
        document.addEventListener('DOMContentLoaded', fn);
      } else {
        document.attachEvent('onreadystatechange', function () {
          if (document.readyState !== 'loading') {
            fn();
          }
        });
      }
    }

    ready(function () {
      Vue.component('product-section', {
        delimiters: ['%%', '%%'],
        template: '{$smarty.capture.template|escape:'javascript':'UTF-8'}',
        store: window.ElasticsearchModule.store,
        data: function () {
          return {
            itemsPerPageOptions: [12, 24, 60],
            busy: false
          }
        },
        computed: {
          query: function () {
            return this.$store.state.query;
          },
          results: function () {
            return this.$store.state.results;
          },
          total: function () {
            return this.$store.state.total;
          },
          maxScore: function () {
            return this.$store.state.maxScore;
          },
          aggregations: function () {
            return this.$store.state.aggregations;
          },
          limit: function () {
            return this.$store.state.limit;
          },
          offset: function () {
            return this.$store.state.offset;
          },
          layoutType: function () {
            return this.$store.state.layoutType;
          },
          classList: function () {
            return window.ElasticsearchModule.classList;
          },
          infiniteScroll: function () {
            return this.$store.state.infiniteScroll;
          },
          fixedFilter: function () {
            return this.$store.state.fixedFilter;
          }
        },
        methods: {
          paginationHandler: function () {
            this.$store.commit('setOffset', 10);
          },
          itemsPerPageHandler: function (event) {
            this.$store.commit('setLimit', parseInt(event.target.value, 10));
          },
          setLayoutType: function (layoutType) {
            if (typeof window.localStorage !== 'undefined'  && _.indexOf(['grid', 'list'], layoutType) > -1) {
              window.localStorage.setItem('es-display', layoutType);

              this.$store.commit('setLayoutType', layoutType);
            }
          },
          loadMoreProducts: function ($state) {
            var currentLimit = this.$store.state.limit;

            this.$store.commit('loadMoreProducts', function (state) {
              if (state.results.length >= currentLimit) {
                $state.loaded();
              } else {
                $state.complete();
              }
            });
          }
        }
      });
    });
  }());
</script>
