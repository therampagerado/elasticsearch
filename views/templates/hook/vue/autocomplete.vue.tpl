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
{* Template file *}
{capture name="template"}{include file=ElasticSearch::tpl('hook/vue/autocomplete.html.tpl')}{/capture}
<script type="text/javascript">
  (function () {
    Vue.component('elasticsearch-autocomplete', {
      delimiters: ['%%', '%%'],
      template: "{$smarty.capture.template|escape:'javascript':'UTF-8'}",
      props: ['selected', 'results'],
      methods: {
        suggestionClicked: function (result, event) {
          event.preventDefault();
          window.location.href = result._source['{Elasticsearch::getAlias('link')|escape:'javascript':'UTF-8'}'];
          this.$store.commit('eraseSuggestions');
        }
      }
    });
  }());
</script>
