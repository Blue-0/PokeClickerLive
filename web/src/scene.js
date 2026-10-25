import * as THREE from 'three';
import {EffectComposer} from 'three/addons/postprocessing/EffectComposer.js';
import {RenderPixelatedPass} from 'three/addons/postprocessing/RenderPixelatedPass.js';
import {OutputPass} from 'three/addons/postprocessing/OutputPass.js';
import {PokemonVoxelLibrary, disposeModel} from './pokemon-voxels.js';
export function createScene(host,onHit){
  const scene=new THREE.Scene();const camera=new THREE.PerspectiveCamera(34,1,.1,100);camera.position.set(7,5.2,9);camera.lookAt(0,.6,0);
  const renderer=new THREE.WebGLRenderer({antialias:false,alpha:true});renderer.setPixelRatio(1);renderer.shadowMap.enabled=true;renderer.shadowMap.type=THREE.PCFSoftShadowMap;renderer.outputColorSpace=THREE.SRGBColorSpace;host.append(renderer.domElement);
  renderer.domElement.setAttribute('aria-hidden','true');
  const composer=new EffectComposer(renderer);
  const pixelPass=new RenderPixelatedPass(2,scene,camera,{normalEdgeStrength:.12,depthEdgeStrength:.2});
  composer.addPass(pixelPass);composer.addPass(new OutputPass());
  const library=new PokemonVoxelLibrary();let requestId=0,disposed=false;
  const reducedQuery=matchMedia('(prefers-reduced-motion: reduce)');
  let reduced=reducedQuery.matches;
  const onReducedChange=event=>{reduced=event.matches;};
  reducedQuery.addEventListener('change',onReducedChange);
  scene.add(new THREE.HemisphereLight(0xf2fbff,0x738367,3));const sun=new THREE.DirectionalLight(0xfff3d6,4);sun.position.set(-4,9,5);sun.castShadow=true;sun.shadow.mapSize.set(1024,1024);scene.add(sun);
  const world=new THREE.Group();scene.add(world);
  const mat=(color,roughness=.85)=>new THREE.MeshStandardMaterial({color,roughness});
  function mesh(geometry,color,parent=world,x=0,y=0,z=0){const m=new THREE.Mesh(geometry,mat(color));m.position.set(x,y,z);m.castShadow=true;m.receiveShadow=true;parent.add(m);return m;}
  const grass=mesh(new THREE.CylinderGeometry(3.05,2.9,.38,64),0x9fbf79,world,0,-.25,0);
  mesh(new THREE.CylinderGeometry(2.9,2.5,.65,12),0xbca27e,world,0,-.74,0);
  mesh(new THREE.CylinderGeometry(2.5,1.8,.45,10),0x9b856d,world,0,-1.25,0);
  const path=mesh(new THREE.TorusGeometry(1.6,.16,8,64),0xc8cc98,world,0,-.035,0);path.rotation.x=Math.PI/2;
  function tree(x,z,s){const group=new THREE.Group();world.add(group);group.position.set(x,0,z);group.scale.setScalar(s);mesh(new THREE.CylinderGeometry(.1,.14,.8,7),0x94765b,group,0,.3,0);mesh(new THREE.ConeGeometry(.58,1.25,7),0x609274,group,0,1.15,0);mesh(new THREE.ConeGeometry(.44,1.05,7),0x76a782,group,0,1.65,0);}
  tree(-1.9,-1.1,1.2);tree(.7,-2.1,1);tree(2,-.75,.85);tree(-2.1,.8,.6);
  for(let i=0;i<22;i++){const a=i*2.4,r=2.2+(i%3)*.14;const x=Math.cos(a)*r,z=Math.sin(a)*r;mesh(new THREE.DodecahedronGeometry(.08,0),i%3?0xe5dc9d:0xf0a09d,world,x,.05,z);}
  const creature=new THREE.Group();world.add(creature);const particles=[];let time=0,impact=0,current='',boss=false;
  function clearCreature(){
    for(const child of [...creature.children]){creature.remove(child);disposeModel(child);}
  }
  async function setEnemy(name,isBoss){
    if(current===name&&boss===isBoss)return;
    current=name;boss=isBoss;const request=++requestId;
    clearCreature();host.dataset.modelState='loading';host.dataset.pokemon=name;
    // A local pixel-art placeholder keeps combat clickable while the sprite decodes.
    const placeholder=mesh(new THREE.BoxGeometry(.7,.7,.35),0xf0d9a1,creature,0,.8,0);
    placeholder.rotation.z=Math.PI/4;
    try{
      const model=await library.load(name);
      if(disposed||request!==requestId){disposeModel(model);return;}
      clearCreature();creature.add(model);
      // The voxel face points toward the camera, with a small angle to show its depth.
      creature.rotation.y=Math.atan2(camera.position.x,camera.position.z)-.12;
      host.dataset.modelState='ready';host.dataset.voxelCount=String(model.count);
      if(isBoss)mesh(new THREE.TorusGeometry(.4,.045,4,24),0xf4cc69,creature,0,2.38,0).rotation.x=Math.PI/2;
    }catch{
      if(disposed||request!==requestId)return;
      host.dataset.modelState='error';
      // The placeholder and the accessible Attack button remain functional.
    }
  }
  function hit(){impact=1;for(let i=0;i<9;i++){const p=mesh(new THREE.BoxGeometry(.07,.07,.07),0xffdc85,scene,0,1,0);particles.push({mesh:p,velocity:new THREE.Vector3((Math.random()-.5)*5,Math.random()*3+1,(Math.random()-.5)*5),life:.55});}}
  const pointer=new THREE.Vector2(),ray=new THREE.Raycaster();
  renderer.domElement.addEventListener('pointerdown',e=>{const r=renderer.domElement.getBoundingClientRect();pointer.set((e.clientX-r.left)/r.width*2-1,-(e.clientY-r.top)/r.height*2+1);ray.setFromCamera(pointer,camera);if(ray.intersectObjects(creature.children).length)onHit(e.clientX,e.clientY);});
  const observer=new ResizeObserver(()=>{const w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;camera.aspect=w/h;camera.updateProjectionMatrix();renderer.setSize(w,h);composer.setSize(w,h);});observer.observe(host);
  return {setEnemy,hit,setZone(index,color){grass.material.color.setHex(color);},render(dt){time+=dt;impact=Math.max(0,impact-dt*5);creature.position.y=reduced?0:Math.sin(time*2.3)*.07;creature.rotation.y=Math.atan2(camera.position.x,camera.position.z)-.12+(reduced?0:Math.sin(time*.8)*.1);const size=(boss?1.25:1)*(1-impact*.12);creature.scale.set(size*(1+impact*.3),size,size*(1+impact*.3));world.rotation.y=reduced?0:Math.sin(time*.16)*.06;
    for(let i=particles.length-1;i>=0;i--){const p=particles[i];p.life-=dt;p.mesh.position.addScaledVector(p.velocity,dt);p.velocity.y-=dt*5;if(p.life<=0){scene.remove(p.mesh);p.mesh.geometry.dispose();p.mesh.material.dispose();particles.splice(i,1);}}
    composer.render(dt);
  },dispose(){disposed=true;++requestId;observer.disconnect();reducedQuery.removeEventListener('change',onReducedChange);scene.traverse(object=>{object.geometry?.dispose();object.material?.dispose();if(object.isInstancedMesh)object.dispose();});pixelPass.dispose();composer.passes.at(-1).dispose();composer.dispose();renderer.dispose();}};
}
