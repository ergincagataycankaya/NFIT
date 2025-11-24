import { Canvas } from '@react-three/fiber'
import { OrbitControls, Environment } from '@react-three/drei'
import { FloatingShapes } from './FloatingShapes'

export const CanvasContainer = () => {
    return (
        <div style={{ position: 'fixed', top: 0, left: 0, width: '100%', height: '100vh', zIndex: -1 }}>
            <Canvas
                camera={{ position: [0, 0, 5] }}
                dpr={[1, 2]} // Clamp pixel ratio for performance
                gl={{ antialias: true, alpha: true }}
            >
                <ambientLight intensity={0.5} />
                <directionalLight position={[10, 10, 5]} intensity={1} />
                <Environment preset="city" />
                <FloatingShapes />
                <OrbitControls enableZoom={false} />
            </Canvas>
        </div>
    )
}
