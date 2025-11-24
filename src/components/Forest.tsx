import { useRef, useMemo, useEffect } from 'react'
import { useData } from '../hooks/useData'
import * as THREE from 'three'

export const Forest = () => {
    const { treeData } = useData()
    const meshRef = useRef<THREE.InstancedMesh>(null)
    const dummy = useMemo(() => new THREE.Object3D(), [])

    // Limit trees for performance if needed, or use all
    const trees = useMemo(() => treeData.slice(0, 5000), [treeData])

    useEffect(() => {
        if (meshRef.current && trees.length > 0) {
            trees.forEach((tree, i) => {
                // Random position if no coordinates, or use plot coordinates if linked
                // For now, we'll scatter them randomly to create a forest effect
                const x = (Math.random() - 0.5) * 100
                const z = (Math.random() - 0.5) * 100
                const y = 0

                // Scale based on tree height or volume if available
                const scale = tree.BOY ? tree.BOY / 10 : 1

                dummy.position.set(x, y, z)
                dummy.scale.set(scale, scale, scale)
                dummy.rotation.y = Math.random() * Math.PI
                dummy.updateMatrix()

                meshRef.current!.setMatrixAt(i, dummy.matrix)

                // Color variation based on species could be added here if using instanceColor
            })
            meshRef.current.instanceMatrix.needsUpdate = true
        }
    }, [trees, dummy])

    return (
        <instancedMesh ref={meshRef} args={[undefined, undefined, trees.length]}>
            <coneGeometry args={[0.5, 2, 8]} />
            <meshStandardMaterial color="#2d5a27" />
        </instancedMesh>
    )
}
