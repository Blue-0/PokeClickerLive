import * as THREE from 'three';
const PALETTE={Lixy:0x71b9e0,Luxio:0x448fc1,Tiplouf:0x71b9e0,Pingoléon:0x2776a0,Tortipouss:0x86b36a,Torterra:0x63895d,Rozbouton:0x99ba60,Ouisticram:0xe69d59,Griknot:0x829cc5,Carchacrok:0x576f9e,Étourmi:0xa59990,Keunotor:0xc29d74,Crikzik:0xdc7866,Mustébouée:0xe7a257};
export function createScene(host,onHit){
  const scene=new THREE.Scene();const camera=new THREE.PerspectiveCamera(34,1,.1,100);camera.position.set(7,5.2,9);camera.lookAt(0,.6,0);
  const renderer=new THREE.WebGLRenderer({antialias:true,alpha:true});renderer.setPixelRatio(Math.min(devicePixelRatio,2));renderer.shadowMap.enabled=true;renderer.shadowMap.type=THREE.PCFSoftShadowMap;renderer.outputColorSpace=THREE.SRGBColorSpace;host.append(renderer.domElement);
  renderer.domElement.setAttribute('aria-hidden','true');
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
  function setEnemy(name,isBoss){if(current===name&&boss===isBoss)return;current=name;boss=isBoss;
    for(const c of [...creature.children]){creature.remove(c);c.geometry?.dispose();c.material?.dispose();}
    const color=PALETTE[name]||0x89b4cc;
    const body=mesh(new THREE.SphereGeometry(.63,24,18),color,creature,0,.65,0);body.scale.set(1,.92,.82);
    mesh(new THREE.SphereGeometry(.49,24,18),color,creature,0,1.36,.12);
    const belly=mesh(new THREE.SphereGeometry(.39,18,14),0xffedc6,creature,0,.68,.39);belly.scale.set(.9,1,.35);
    for(const x of [-.32,.32]){mesh(new THREE.SphereGeometry(.19,16,12),color,creature,x,.15,.28);const ear=mesh(new THREE.ConeGeometry(.22,.5,3),color,creature,x,1.9,.09);ear.rotation.z=-x*.7;mesh(new THREE.SphereGeometry(.105,16,12),0x22343c,creature,x*.7,1.44,.545);mesh(new THREE.SphereGeometry(.035,12,8),0xffffff,creature,x*.7+.025,1.475,.63);}
    mesh(new THREE.SphereGeometry(.075,12,10),0x34414a,creature,0,1.27,.61);
    const tail=mesh(new THREE.ConeGeometry(.19,.7,5),0xf4cc69,creature,.68,.8,-.23);tail.rotation.z=-1;
    if(isBoss)mesh(new THREE.TorusGeometry(.4,.055,8,32),0xf4cc69,creature,0,2.18,0).rotation.x=Math.PI/2;
  }
  function hit(){impact=1;for(let i=0;i<9;i++){const p=mesh(new THREE.SphereGeometry(.04,6,6),0xffdc85,scene,0,1,0);particles.push({mesh:p,velocity:new THREE.Vector3((Math.random()-.5)*5,Math.random()*3+1,(Math.random()-.5)*5),life:.55});}}
  const pointer=new THREE.Vector2(),ray=new THREE.Raycaster();
  renderer.domElement.addEventListener('pointerdown',e=>{const r=renderer.domElement.getBoundingClientRect();pointer.set((e.clientX-r.left)/r.width*2-1,-(e.clientY-r.top)/r.height*2+1);ray.setFromCamera(pointer,camera);if(ray.intersectObjects(creature.children).length)onHit(e.clientX,e.clientY);});
  const observer=new ResizeObserver(()=>{const w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;camera.aspect=w/h;camera.updateProjectionMatrix();renderer.setSize(w,h);});observer.observe(host);
  let reduced=matchMedia('(prefers-reduced-motion: reduce)').matches;
  return {setEnemy,hit,setZone(index,color){grass.material.color.setHex(color);},render(dt){time+=dt;impact=Math.max(0,impact-dt*5);creature.position.y=reduced?0:Math.sin(time*2.3)*.07;creature.rotation.y=.3+(reduced?0:Math.sin(time*.8)*.13);const size=(boss?1.25:1)*(1-impact*.12);creature.scale.set(size*(1+impact*.3),size,size*(1+impact*.3));world.rotation.y=reduced?0:Math.sin(time*.16)*.06;
    for(let i=particles.length-1;i>=0;i--){const p=particles[i];p.life-=dt;p.mesh.position.addScaledVector(p.velocity,dt);p.velocity.y-=dt*5;if(p.life<=0){scene.remove(p.mesh);p.mesh.geometry.dispose();p.mesh.material.dispose();particles.splice(i,1);}}
    renderer.render(scene,camera);
  },dispose(){observer.disconnect();renderer.dispose();}};
}
