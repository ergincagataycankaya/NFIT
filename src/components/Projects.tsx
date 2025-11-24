import { useEffect, useRef } from 'react'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { useLanguage } from '../contexts/LanguageContext'

gsap.registerPlugin(ScrollTrigger)

export const Projects = () => {
    const { t } = useLanguage()
    const sectionRef = useRef<HTMLElement>(null)
    const titleRef = useRef<HTMLHeadingElement>(null)
    const projectsRef = useRef<HTMLDivElement>(null)

    useEffect(() => {
        const ctx = gsap.context(() => {
            gsap.from(titleRef.current, {
                scrollTrigger: {
                    trigger: sectionRef.current,
                    start: 'top 80%',
                    end: 'top 50%',
                    scrub: 1,
                },
                y: 100,
                opacity: 0,
            })

            const projects = projectsRef.current?.children
            if (projects) {
                Array.from(projects).forEach((project, i) => {
                    gsap.from(project, {
                        scrollTrigger: {
                            trigger: project,
                            start: 'top 90%',
                            end: 'top 70%',
                            scrub: 1,
                        },
                        y: 50,
                        opacity: 0,
                        delay: i * 0.1,
                    })
                })
            }
        }, sectionRef)

        return () => ctx.revert()
    }, [])

    return (
        <section ref={sectionRef} style={{ minHeight: '100vh', padding: '4rem 1rem', position: 'relative', zIndex: 1 }}>
            <h2 ref={titleRef} style={{ fontSize: 'var(--font-size-h2)', marginBottom: '4rem', textAlign: 'center' }}>{t('selectedWorks')}</h2>
            <div ref={projectsRef} style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.5rem', maxWidth: '1200px', margin: '0 auto' }}>
                {[1, 2, 3, 4].map((item) => (
                    <div key={item} style={{
                        background: 'rgba(255,255,255,0.05)',
                        padding: '1.5rem',
                        borderRadius: '16px',
                        backdropFilter: 'blur(10px)',
                        border: '1px solid rgba(255,255,255,0.1)'
                    }}>
                        <div style={{ height: '200px', background: 'rgba(255,255,255,0.1)', borderRadius: '8px', marginBottom: '1rem' }}></div>
                        <h3 style={{ fontSize: '1.5rem', margin: '0 0 0.5rem 0' }}>{t('project')} {item}</h3>
                        <p style={{ fontSize: '1rem', color: 'rgba(255,255,255,0.7)' }}>A stunning web application built with modern technologies.</p>
                    </div>
                ))}
            </div>
        </section>
    )
}
