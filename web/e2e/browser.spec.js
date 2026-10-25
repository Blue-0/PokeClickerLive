import {test,expect} from '@playwright/test';
test('3D combat, upgrades, boss unlocks and persistence',async({page})=>{
 test.setTimeout(60000);
 const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto('/');await expect(page.locator('#scene canvas')).toBeVisible();await expect(page.locator('#scene-fallback')).toBeHidden();
 await expect(page.locator('#boss')).toBeDisabled();
 const attack=page.getByRole('button',{name:/Attaquer/});
 for(let i=0;i<110;i++)await attack.click();
 await expect(page.locator('#boss')).toBeEnabled();
 await page.locator('[data-upgrade="click"]').click();await expect(page.locator('#level-click')).toHaveText('Niv. 1');
 await page.locator('#boss').click();await expect(page.locator('#enemy-kind')).toHaveText('GARDIEN DE LA ZONE');
 for(let i=0;i<40;i++)await attack.click();
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
