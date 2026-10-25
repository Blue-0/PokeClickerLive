// Local subset of PokeAPI/sprites, pinned and attributed in public/pokemon/.
export const POKEMON_IDS = Object.freeze({
  Tortipouss: 387, Torterra: 389, Ouisticram: 390, Tiplouf: 393,
  Pingoléon: 395, Étourmi: 396, Keunotor: 399, Crikzik: 401,
  Lixy: 403, Luxio: 404, Rozbouton: 406, Mustébouée: 418,
  Griknot: 443, Carchacrok: 445,
});
export function pokemonSprite(name) {
  const id = POKEMON_IDS[name];
  return id ? `${import.meta.env?.BASE_URL ?? '/'}pokemon/${id}.png` : null;
}

// Crop transparent padding, keep the original pixels and normalize model size.
export function voxelData(width, height, rgba) {
  const pixels = [];
  let minX = width, maxX = -1, minY = height, maxY = -1;
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const i = (y * width + x) * 4;
      if (rgba[i + 3] < 128) continue;
      pixels.push({x, y, rgb: [rgba[i], rgba[i + 1], rgba[i + 2]]});
      minX = Math.min(minX, x); maxX = Math.max(maxX, x);
      minY = Math.min(minY, y); maxY = Math.max(maxY, y);
    }
  }
  if (!pixels.length) throw new Error('Empty Pokémon sprite');
  const unit = Math.min(2.1 / (maxY - minY + 1), 2.5 / (maxX - minX + 1));
  const centerX = (minX + maxX) / 2;
  return {unit, pixels: pixels.map(p => ({
    x: (p.x - centerX) * unit,
    y: (maxY - p.y + .5) * unit + .06,
    rgb: p.rgb,
  }))};
}
