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
<div class="col-md-2">
  <div v-for="tabGroup in tabGroups" class="list-group">
    <a v-for="tab in tabGroup"
       v-bind:href="'#tab-' + tab.key"
       v-bind:class="'list-group-item ' + (tab.key == currentTab ? 'active' : '')"
       v-on:click="setTab(tab.key)"
    >
      <i :class="'icon icon-' + tab.icon"></i> %% tab.name %%
    </a>
  </div>
</div>
