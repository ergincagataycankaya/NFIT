import { Float } from '@react-three/drei'

export const FloatingShapes = () => {
    return (
        <group>
            <Float speed={1.5} rotationIntensity={1} floatIntensity={2}>
                <mesh position={[1, 1, 0]}>
                    <torusKnotGeometry args={[0.5, 0.15, 100, 16]} />
                    <meshStandardMaterial color="#646cff" roughness={0.1} metalness={0.5} />
                </mesh>
            </Float>

            <Float speed={2} rotationIntensity={1.5} floatIntensity={1.5}>
                <mesh position={[-1, -1, -1]}>
                    <octahedronGeometry args={[0.5]} />
                    <meshStandardMaterial color="#ff6464" roughness={0.1} metalness={0.5} />
                </mesh>
            </Float>

            <Float speed={1} rotationIntensity={0.5} floatIntensity={1}>
                <mesh position={[2, -0.5, -2]}>
                    <boxGeometry args={[0.5, 0.5, 0.5]} />
                    <meshStandardMaterial color="#64ff64" roughness={0.1} metalness={0.5} />
                </mesh>
            </Float>
        </group>
    )
}
