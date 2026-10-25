import {test,expect} from '@playwright/test';
test('3D combat, upgrades, boss unlocks and persistence',async({page})=>{
 test.setTimeout(60000);
 const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto('/');await expect(page.locator('#scene canvas')).toBeVisible();await expect(page.locator('#scene-fallback')).toBeHidden();
 await expect(page.locator('#scene')).toHaveAttribute('data-model-state','ready');
 expect(Number(await page.locator('#scene').getAttribute('data-voxel-count'))).toBeGreaterThan(100);
 await expect(page.locator('#boss')).toBeDisabled();
 const attack=page.getByRole('button',{name:/attaquer/i});
 for(let i=0;i<110;i++)await attack.click();
 await expect(page.locator('#boss')).toBeEnabled();
 await page.locator('[data-upgrade="click"]').click();await expect(page.locator('#level-click')).toHaveText('Niv. 1');
 await page.locator('#boss').click();await expect(page.locator('#enemy-kind')).toHaveText('GARDIEN DE LA ZONE');
 for(let i=0;i<40;i++)await attack.click();
 await page.getByRole('button',{name:'CARTE',exact:true}).click();
 await expect(page.locator('[data-zone="1"]')).toBeEnabled();
 await page.locator('[data-zone="1"]').click();await expect(page.locator('#zone-name')).toHaveText('Forêt de Vestigion');
 await page.locator('#skill').click();await expect(page.locator('#skill')).toBeDisabled();
 await page.waitForTimeout(5200);await page.reload();
 await expect(page.locator('#zone-name')).toHaveText('Forêt de Vestigion');await expect(page.locator('#level-click')).toHaveText('Niv. 1');
 await page.screenshot({path:'/tmp/pokeclicker-desktop.png',fullPage:true});expect(errors).toEqual([]);
});
test('mobile layout, keyboard combat and guide',async({page})=>{
 await page.setViewportSize({width:390,height:844});await page.goto('/');
 await page.keyboard.press('Space');await expect(page.locator('#health-text')).not.toHaveText('28 / 28 PV');
 await page.locator('#help').click();await expect(page.getByRole('dialog')).toBeVisible();await page.keyboard.press('Escape');await expect(page.getByRole('dialog')).toBeHidden();
 expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)).toBe(true);
 await page.screenshot({path:'/tmp/pokeclicker-mobile.png',fullPage:true});
});
test('WebGL failure keeps the clicker playable',async({page})=>{
 await page.addInitScript(()=>{const get=HTMLCanvasElement.prototype.getContext;HTMLCanvasElement.prototype.getContext=function(kind,...args){if(kind.startsWith('webgl'))return null;return get.call(this,kind,...args);};});
 await page.goto('/');await expect(page.locator('#scene-fallback')).toBeVisible();await page.locator('#attack').click();await expect(page.locator('#health-text')).not.toHaveText('28 / 28 PV');
});

test('pixel assets stay local and sprite failures preserve combat',async({page})=>{
 await page.route('**/pokemon/*.png',route=>route.abort());
 await page.goto('/');await expect(page.locator('#scene')).toHaveAttribute('data-model-state','error');
 await page.locator('#attack').click();await expect(page.locator('#health-text')).not.toHaveText('28 / 28 PV');
});

test('DS menus work by keyboard and keep combat accessible on mobile',async({page})=>{
 await page.setViewportSize({width:390,height:844});await page.goto('/');
 const bag=page.getByRole('button',{name:'SAC',exact:true});
 await expect(bag).toHaveAttribute('aria-pressed','true');
 await expect(page.locator('#menu-upgrades')).toBeVisible();
 await expect(page.locator('#menu-journey')).toBeHidden();
 const map=page.getByRole('button',{name:'CARTE',exact:true});await map.focus();await page.keyboard.press('Enter');
 await expect(map).toHaveAttribute('aria-pressed','true');await expect(page.locator('#menu-journey')).toBeVisible();
 await expect(page.locator('#menu-upgrades')).toBeHidden();await expect(page.locator('.map-point.current')).toHaveCount(1);
 await page.getByRole('button',{name:'ÉQUIPE',exact:true}).click();await expect(page.locator('.empty-team')).toBeVisible();
 await page.getByRole('button',{name:'BADGES',exact:true}).click();await expect(page.locator('.badge-case span')).toHaveCount(4);await expect(page.locator('#prestige')).toBeDisabled();
 await bag.click();await expect(page.locator('#menu-upgrades')).toBeVisible();
 await page.locator('#attack').click();await expect(page.locator('#health-text')).not.toHaveText('28 / 28 PV');
 expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)).toBe(true);
 const loaded=await page.evaluate(()=>document.fonts.load('20px Sinnoh').then(fonts=>fonts.length));expect(loaded).toBeGreaterThan(0);
});
