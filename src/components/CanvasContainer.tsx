import { Canvas } from '@react-three/fiber'
import { OrbitControls, Environment } from '@react-three/drei'
import { FloatingShapes } from './FloatingShapes'
import { Forest } from './Forest'

export const CanvasContainer = () => {
    return (
        <div style={{ position: 'fixed', top: 0, left: 0, width: '100%', height: '100vh', zIndex: -1 }}>
            <Canvas
                camera={{ position: [0, 5, 10] }}
                dpr={[1, 2]}
                gl={{ antialias: true, alpha: true }}
            >
                <ambientLight intensity={0.5} />
                <directionalLight position={[10, 10, 5]} intensity={1} />
                <Environment preset="city" />
                <FloatingShapes />
                <Forest />
                <OrbitControls enableZoom={true} maxPolarAngle={Math.PI / 2} />
            </Canvas>
        </div>
    )
}
