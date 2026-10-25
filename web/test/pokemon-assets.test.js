import {test} from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createHash} from 'node:crypto';
import {ZONES} from '../src/game.js';
import {POKEMON_IDS,pokemonSprite,voxelData} from '../src/pokemon-assets.js';
test('every encounter has an intact local sprite with recorded provenance',()=>{
 const root=new URL('../public/pokemon/',import.meta.url);
 const manifest=JSON.parse(readFileSync(new URL('sources.json',root)));
 for(const name of new Set(ZONES.flatMap(z=>[...z.species,z.boss]))){
  const id=POKEMON_IDS[name],source=manifest.find(row=>row.id===id);
  assert.ok(source,`Missing ${name}`);assert.equal(pokemonSprite(name),`/pokemon/${id}.png`);
  const png=readFileSync(new URL(`${id}.png`,root));
  assert.equal(createHash('sha256').update(png).digest('hex'),source.sha256);
  assert.equal(png.readUInt32BE(16),96);assert.equal(png.readUInt32BE(20),96);
 }
});
test('voxel conversion crops padding, preserves colors and ignores transparency',()=>{
 const rgba=new Uint8ClampedArray(4*4*4);
 rgba.set([255,0,0,255],(1*4+1)*4);rgba.set([0,255,0,255],(2*4+2)*4);
 rgba.set([0,0,255,80],(0*4+0)*4);
 const {unit,pixels}=voxelData(4,4,rgba);assert.equal(pixels.length,2);
 assert.deepEqual(pixels[0].rgb,[255,0,0]);assert.deepEqual(pixels[1].rgb,[0,255,0]);
 assert.equal(pixels[0].x,-unit/2);assert.ok(pixels[0].y>pixels[1].y);
 assert.throws(()=>voxelData(1,1,new Uint8ClampedArray(4)),/Empty/);
 assert.equal(pokemonSprite('Unknown'),null);
});
