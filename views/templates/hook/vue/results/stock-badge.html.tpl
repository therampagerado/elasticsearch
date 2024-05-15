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
<div v-if="{if !$PS_CATALOG_MODE && $PS_STOCK_MANAGEMENT}true{else}false{/if} && item._source['{Elasticsearch::getAlias('show_price')|escape:'javascript':'UTF-8'}'] || item._source['{Elasticsearch::getAlias('available_for_order')|escape:'javascript':'UTF-8'}']"
     class="availability"
>
  <span v-if="!item._source['{Elasticsearch::getAlias('in_stock')|escape:'javascript':'UTF-8'}'] && item._source['{Elasticsearch::getAlias('available_later')|escape:'javascript':'UTF-8'}']" class="label label-danger">%% item._source['{Elasticsearch::getAlias('available_later')|escape:'javascript':'UTF-8'}']</span>
  <span v-else-if="!item._source['{Elasticsearch::getAlias('in_stock')|escape:'javascript':'UTF-8'}']" class="label label-danger">{l s='Out of stock' mod='elasticsearch'}</span>
  <span v-else-if="item._source['{Elasticsearch::getAlias('available_now')|escape:'javascript':'UTF-8'}']" class="label label-success">{l s='In stock' mod='elasticsearch'}</span>
  <span v-else class="label label-success">{l s='In stock' mod='elasticsearch'}</span>
</div>
