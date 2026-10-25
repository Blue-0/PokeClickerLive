import * as THREE from 'three';
import {pokemonSprite, voxelData} from './pokemon-assets.js';

// Cache CPU sprite data. Every model owns its GPU buffers and can be disposed safely.
export class PokemonVoxelLibrary {
  #sprites = new Map();

  async load(name) {
    const url = pokemonSprite(name);
    if (!url) throw new Error(`Unknown Pokémon: ${name}`);
    if (!this.#sprites.has(url)) {
      const pending = new Promise((resolve, reject) => {
        const image = new Image();
        image.onload = () => {
          try {
            const canvas = document.createElement('canvas');
            canvas.width = image.naturalWidth; canvas.height = image.naturalHeight;
            const context = canvas.getContext('2d', {willReadFrequently: true});
            context.imageSmoothingEnabled = false;
            context.drawImage(image, 0, 0);
            resolve(voxelData(canvas.width, canvas.height,
              context.getImageData(0, 0, canvas.width, canvas.height).data));
          } catch (error) { reject(error); }
        };
        image.onerror = () => reject(new Error(`Cannot load sprite: ${name}`));
        image.src = url;
      });
      this.#sprites.set(url, pending);
      pending.catch(() => this.#sprites.delete(url));
    }
    const {unit, pixels} = await this.#sprites.get(url);
    const geometry = new THREE.BoxGeometry(unit, unit, .28);
    const material = new THREE.MeshStandardMaterial({roughness: 1, metalness: 0});
    const model = new THREE.InstancedMesh(geometry, material, pixels.length);
    const matrix = new THREE.Matrix4(), color = new THREE.Color();
    pixels.forEach((pixel, index) => {
      matrix.makeTranslation(pixel.x, pixel.y, 0);
      model.setMatrixAt(index, matrix);
      color.setRGB(...pixel.rgb.map(c => c / 255), THREE.SRGBColorSpace);
      model.setColorAt(index, color);
    });
    model.instanceMatrix.needsUpdate = true;
    model.instanceColor.needsUpdate = true;
    model.castShadow = true; model.receiveShadow = true;
    model.name = name;
    model.computeBoundingSphere();
    return model;
  }
}

export function disposeModel(model) {
  model.traverse(object => {
    object.geometry?.dispose();
    if (Array.isArray(object.material)) object.material.forEach(m => m.dispose());
    else object.material?.dispose();
    // InstancedMesh.dispose also releases its per-instance GPU data.
    if (object.isInstancedMesh) object.dispose();
  });
}
