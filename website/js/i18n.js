/**
 * Ndmr Website - Internationalization
 */

const translations = {
    fr: {
        lang: "Français",
        flag: "🇫🇷",
        nav: {
            features: "Fonctionnalités",
            screenshots: "Aperçu",
            download: "Télécharger",
            about: "À propos",
            contact: "Contact"
        },
        hero: {
            badge: "Version 0.14.0 disponible",
            title1: "Programmez votre radio DMR",
            title2: "simplement",
            description: "Ndmr est un logiciel moderne et gratuit pour créer et éditer vos codeplugs DMR. Multiplateforme, intuitif, pensé pour les radioamateurs débutants comme experts.",
            download: "Télécharger",
            github: "Voir sur GitHub",
            platforms: "Disponible sur"
        },
        features: {
            title: "Tout ce dont vous avez besoin",
            subtitle: "Ndmr regroupe tous les outils pour programmer votre radio DMR efficacement",
            multiplatform: {
                title: "Multiplateforme",
                desc: "Windows, macOS, Linux, Android et iOS. Utilisez Ndmr sur tous vos appareils."
            },
            intuitive: {
                title: "Interface intuitive",
                desc: "Conçue pour les débutants avec des tooltips explicatifs pour chaque paramètre DMR."
            },
            repeaterbook: {
                title: "Import Repeaterbook",
                desc: "Importez les relais DMR directement depuis Repeaterbook.com en quelques clics."
            },
            export: {
                title: "Export multiformats",
                desc: "Exportez en CSV, PDF ou format natif. Compatible avec les fichiers qdmr (.yaml)."
            },
            validation: {
                title: "Validation intelligente",
                desc: "Détection automatique des erreurs et incohérences avant l'export vers la radio."
            },
            themes: {
                title: "Thèmes clair/sombre",
                desc: "Interface adaptative avec thème automatique selon vos préférences système."
            }
        },
        screenshots: {
            title: "Découvrez l'interface",
            subtitle: "Une interface moderne et épurée pour une expérience utilisateur optimale",
            dashboard: {
                title: "Dashboard",
                desc: "Vue d'ensemble de votre codeplug avec statistiques"
            },
            channels: {
                title: "Gestion des canaux",
                desc: "Créez et organisez vos canaux DMR facilement"
            },
            zones: {
                title: "Organisation par zones",
                desc: "Regroupez vos canaux par zone géographique"
            }
        },
        radios: {
            title: "Radios supportées",
            subtitle: "Ndmr supporte les radios DMR les plus populaires",
            supported: "Supporté",
            coming: "Bientôt",
            anytone: {
                title: "Anytone AT-D878UV",
                desc: "Support complet avec toutes les fonctionnalités"
            },
            opengd77: {
                title: "OpenGD77 / OpenRTX",
                desc: "Support prévu pour les firmwares open-source"
            },
            tyt: {
                title: "TYT MD-UV380/390",
                desc: "Support prévu dans une prochaine version"
            },
            radioddity: {
                title: "Radioddity GD-77",
                desc: "Support prévu dans une prochaine version"
            }
        },
        download: {
            title: "Prêt à programmer votre radio ?",
            subtitle: "Téléchargez Ndmr gratuitement et commencez à créer votre codeplug en quelques minutes.",
            for: "Télécharger pour",
            note: "Gratuit et open-source",
            allVersions: "Voir toutes les versions"
        },
        footer: {
            tagline: "Programmation DMR simplifiée pour tous les radioamateurs.",
            resources: "Ressources",
            sourceCode: "Code source",
            versions: "Versions",
            reportBug: "Signaler un bug",
            community: "Communauté",
            copyright: "Open-source sous licence MIT.",
            inspired: "Inspiré par"
        },
        about: {
            title: "À propos",
            subtitle: "Le projet et son auteur",
            developer: "Développé par",
            description: "Radioamateur et développeur logiciel, passionné par le DMR et les technologies open-source.",
            openSource: "Open Source",
            license: "Ndmr est un logiciel libre publié sous licence MIT. Le code source est disponible sur GitHub.",
            viewSource: "Voir le code source"
        },
        contact: {
            title: "Contact & Feedback",
            subtitle: "Questions, suggestions ou bugs ? Dites-nous tout !",
            name: "Nom",
            callsign: "Indicatif (optionnel)",
            email: "Email",
            type: "Type",
            typeFeedback: "Retour général",
            typeBug: "Rapport de bug",
            typeFeature: "Demande de fonctionnalité",
            typeContact: "Contact",
            message: "Message",
            send: "Envoyer",
            direct: "Contact direct",
            directDesc: "Pour les questions urgentes ou collaborations",
            issues: "Signaler un problème",
            issuesDesc: "Ouvrez une issue sur GitHub"
        }
    },
    en: {
        lang: "English",
        flag: "🇬🇧",
        nav: {
            features: "Features",
            screenshots: "Preview",
            download: "Download",
            about: "About",
            contact: "Contact"
        },
        hero: {
            badge: "Version 0.14.0 available",
            title1: "Program your DMR radio",
            title2: "easily",
            description: "Ndmr is a modern, free software to create and edit your DMR codeplugs. Cross-platform, intuitive, designed for beginner and expert amateur radio operators alike.",
            download: "Download",
            github: "View on GitHub",
            platforms: "Available on"
        },
        features: {
            title: "Everything you need",
            subtitle: "Ndmr brings together all the tools to program your DMR radio efficiently",
            multiplatform: {
                title: "Cross-platform",
                desc: "Windows, macOS, Linux, Android and iOS. Use Ndmr on all your devices."
            },
            intuitive: {
                title: "Intuitive interface",
                desc: "Designed for beginners with explanatory tooltips for each DMR parameter."
            },
            repeaterbook: {
                title: "Repeaterbook import",
                desc: "Import DMR repeaters directly from Repeaterbook.com in a few clicks."
            },
            export: {
                title: "Multi-format export",
                desc: "Export to CSV, PDF or native format. Compatible with qdmr files (.yaml)."
            },
            validation: {
                title: "Smart validation",
                desc: "Automatic detection of errors and inconsistencies before exporting to radio."
            },
            themes: {
                title: "Light/dark themes",
                desc: "Adaptive interface with automatic theme based on your system preferences."
            }
        },
        screenshots: {
            title: "Discover the interface",
            subtitle: "A modern and clean interface for an optimal user experience",
            dashboard: {
                title: "Dashboard",
                desc: "Overview of your codeplug with statistics"
            },
            channels: {
                title: "Channel management",
                desc: "Create and organize your DMR channels easily"
            },
            zones: {
                title: "Zone organization",
                desc: "Group your channels by geographic zone"
            }
        },
        radios: {
            title: "Supported radios",
            subtitle: "Ndmr supports the most popular DMR radios",
            supported: "Supported",
            coming: "Coming soon",
            anytone: {
                title: "Anytone AT-D878UV",
                desc: "Full support with all features"
            },
            opengd77: {
                title: "OpenGD77 / OpenRTX",
                desc: "Support planned for open-source firmwares"
            },
            tyt: {
                title: "TYT MD-UV380/390",
                desc: "Support planned in a future version"
            },
            radioddity: {
                title: "Radioddity GD-77",
                desc: "Support planned in a future version"
            }
        },
        download: {
            title: "Ready to program your radio?",
            subtitle: "Download Ndmr for free and start creating your codeplug in minutes.",
            for: "Download for",
            note: "Free and open-source",
            allVersions: "View all versions"
        },
        footer: {
            tagline: "Simplified DMR programming for all amateur radio operators.",
            resources: "Resources",
            sourceCode: "Source code",
            versions: "Releases",
            reportBug: "Report a bug",
            community: "Community",
            copyright: "Open-source under MIT license.",
            inspired: "Inspired by"
        },
        about: {
            title: "About",
            subtitle: "The project and its author",
            developer: "Developed by",
            description: "Amateur radio operator and software developer, passionate about DMR and open-source technologies.",
            openSource: "Open Source",
            license: "Ndmr is free software released under the MIT license. The source code is available on GitHub.",
            viewSource: "View Source Code"
        },
        contact: {
            title: "Contact & Feedback",
            subtitle: "Questions, suggestions, or bugs? Let us know!",
            name: "Name",
            callsign: "Callsign (optional)",
            email: "Email",
            type: "Type",
            typeFeedback: "General Feedback",
            typeBug: "Bug Report",
            typeFeature: "Feature Request",
            typeContact: "Contact",
            message: "Message",
            send: "Send",
            direct: "Direct Contact",
            directDesc: "For urgent matters or collaborations",
            issues: "Report Issues",
            issuesDesc: "Open an issue on GitHub"
        }
    },
    es: {
        lang: "Español",
        flag: "🇪🇸",
        nav: {
            features: "Características",
            screenshots: "Vista previa",
            download: "Descargar",
            about: "Acerca de",
            contact: "Contacto"
        },
        hero: {
            badge: "Versión 0.14.0 disponible",
            title1: "Programa tu radio DMR",
            title2: "fácilmente",
            description: "Ndmr es un software moderno y gratuito para crear y editar tus codeplugs DMR. Multiplataforma, intuitivo, diseñado para radioaficionados principiantes y expertos.",
            download: "Descargar",
            github: "Ver en GitHub",
            platforms: "Disponible en"
        },
        features: {
            title: "Todo lo que necesitas",
            subtitle: "Ndmr reúne todas las herramientas para programar tu radio DMR eficientemente",
            multiplatform: {
                title: "Multiplataforma",
                desc: "Windows, macOS, Linux, Android e iOS. Usa Ndmr en todos tus dispositivos."
            },
            intuitive: {
                title: "Interfaz intuitiva",
                desc: "Diseñada para principiantes con tooltips explicativos para cada parámetro DMR."
            },
            repeaterbook: {
                title: "Importar Repeaterbook",
                desc: "Importa repetidores DMR directamente desde Repeaterbook.com en pocos clics."
            },
            export: {
                title: "Exportación multiformato",
                desc: "Exporta a CSV, PDF o formato nativo. Compatible con archivos qdmr (.yaml)."
            },
            validation: {
                title: "Validación inteligente",
                desc: "Detección automática de errores e inconsistencias antes de exportar a la radio."
            },
            themes: {
                title: "Temas claro/oscuro",
                desc: "Interfaz adaptativa con tema automático según las preferencias del sistema."
            }
        },
        screenshots: {
            title: "Descubre la interfaz",
            subtitle: "Una interfaz moderna y limpia para una experiencia de usuario óptima",
            dashboard: {
                title: "Panel de control",
                desc: "Vista general de tu codeplug con estadísticas"
            },
            channels: {
                title: "Gestión de canales",
                desc: "Crea y organiza tus canales DMR fácilmente"
            },
            zones: {
                title: "Organización por zonas",
                desc: "Agrupa tus canales por zona geográfica"
            }
        },
        radios: {
            title: "Radios compatibles",
            subtitle: "Ndmr soporta las radios DMR más populares",
            supported: "Soportado",
            coming: "Próximamente",
            anytone: {
                title: "Anytone AT-D878UV",
                desc: "Soporte completo con todas las funciones"
            },
            opengd77: {
                title: "OpenGD77 / OpenRTX",
                desc: "Soporte previsto para firmwares de código abierto"
            },
            tyt: {
                title: "TYT MD-UV380/390",
                desc: "Soporte previsto en una versión futura"
            },
            radioddity: {
                title: "Radioddity GD-77",
                desc: "Soporte previsto en una versión futura"
            }
        },
        download: {
            title: "¿Listo para programar tu radio?",
            subtitle: "Descarga Ndmr gratis y comienza a crear tu codeplug en minutos.",
            for: "Descargar para",
            note: "Gratis y de código abierto",
            allVersions: "Ver todas las versiones"
        },
        footer: {
            tagline: "Programación DMR simplificada para todos los radioaficionados.",
            resources: "Recursos",
            sourceCode: "Código fuente",
            versions: "Versiones",
            reportBug: "Reportar un error",
            community: "Comunidad",
            copyright: "Código abierto bajo licencia MIT.",
            inspired: "Inspirado por"
        },
        about: {
            title: "Acerca de",
            subtitle: "El proyecto y su autor",
            developer: "Desarrollado por",
            description: "Radioaficionado y desarrollador de software, apasionado por el DMR y las tecnologías de código abierto.",
            openSource: "Código Abierto",
            license: "Ndmr es software libre publicado bajo la licencia MIT. El código fuente está disponible en GitHub.",
            viewSource: "Ver código fuente"
        },
        contact: {
            title: "Contacto y Feedback",
            subtitle: "¿Preguntas, sugerencias o errores? ¡Cuéntanos!",
            name: "Nombre",
            callsign: "Indicativo (opcional)",
            email: "Email",
            type: "Tipo",
            typeFeedback: "Comentario general",
            typeBug: "Reporte de error",
            typeFeature: "Solicitud de función",
            typeContact: "Contacto",
            message: "Mensaje",
            send: "Enviar",
            direct: "Contacto directo",
            directDesc: "Para asuntos urgentes o colaboraciones",
            issues: "Reportar problemas",
            issuesDesc: "Abre una issue en GitHub"
        }
    },
    pt: {
        lang: "Português",
        flag: "🇧🇷",
        nav: {
            features: "Recursos",
            screenshots: "Prévia",
            download: "Baixar",
            about: "Sobre",
            contact: "Contato"
        },
        hero: {
            badge: "Versão 0.14.0 disponível",
            title1: "Programe seu rádio DMR",
            title2: "facilmente",
            description: "Ndmr é um software moderno e gratuito para criar e editar seus codeplugs DMR. Multiplataforma, intuitivo, projetado para radioamadores iniciantes e experientes.",
            download: "Baixar",
            github: "Ver no GitHub",
            platforms: "Disponível em"
        },
        features: {
            title: "Tudo o que você precisa",
            subtitle: "Ndmr reúne todas as ferramentas para programar seu rádio DMR eficientemente",
            multiplatform: {
                title: "Multiplataforma",
                desc: "Windows, macOS, Linux, Android e iOS. Use Ndmr em todos os seus dispositivos."
            },
            intuitive: {
                title: "Interface intuitiva",
                desc: "Projetada para iniciantes com tooltips explicativos para cada parâmetro DMR."
            },
            repeaterbook: {
                title: "Importar Repeaterbook",
                desc: "Importe repetidoras DMR diretamente do Repeaterbook.com em poucos cliques."
            },
            export: {
                title: "Exportação multiformato",
                desc: "Exporte para CSV, PDF ou formato nativo. Compatível com arquivos qdmr (.yaml)."
            },
            validation: {
                title: "Validação inteligente",
                desc: "Detecção automática de erros e inconsistências antes de exportar para o rádio."
            },
            themes: {
                title: "Temas claro/escuro",
                desc: "Interface adaptativa com tema automático baseado nas preferências do sistema."
            }
        },
        screenshots: {
            title: "Descubra a interface",
            subtitle: "Uma interface moderna e limpa para uma experiência de usuário ideal",
            dashboard: {
                title: "Painel",
                desc: "Visão geral do seu codeplug com estatísticas"
            },
            channels: {
                title: "Gestão de canais",
                desc: "Crie e organize seus canais DMR facilmente"
            },
            zones: {
                title: "Organização por zonas",
                desc: "Agrupe seus canais por zona geográfica"
            }
        },
        radios: {
            title: "Rádios suportados",
            subtitle: "Ndmr suporta os rádios DMR mais populares",
            supported: "Suportado",
            coming: "Em breve",
            anytone: {
                title: "Anytone AT-D878UV",
                desc: "Suporte completo com todos os recursos"
            },
            opengd77: {
                title: "OpenGD77 / OpenRTX",
                desc: "Suporte planejado para firmwares de código aberto"
            },
            tyt: {
                title: "TYT MD-UV380/390",
                desc: "Suporte planejado em uma versão futura"
            },
            radioddity: {
                title: "Radioddity GD-77",
                desc: "Suporte planejado em uma versão futura"
            }
        },
        download: {
            title: "Pronto para programar seu rádio?",
            subtitle: "Baixe Ndmr gratuitamente e comece a criar seu codeplug em minutos.",
            for: "Baixar para",
            note: "Gratuito e de código aberto",
            allVersions: "Ver todas as versões"
        },
        footer: {
            tagline: "Programação DMR simplificada para todos os radioamadores.",
            resources: "Recursos",
            sourceCode: "Código fonte",
            versions: "Versões",
            reportBug: "Reportar um bug",
            community: "Comunidade",
            copyright: "Código aberto sob licença MIT.",
            inspired: "Inspirado por"
        },
        about: {
            title: "Sobre",
            subtitle: "O projeto e seu autor",
            developer: "Desenvolvido por",
            description: "Radioamador e desenvolvedor de software, apaixonado por DMR e tecnologias de código aberto.",
            openSource: "Código Aberto",
            license: "Ndmr é software livre publicado sob a licença MIT. O código fonte está disponível no GitHub.",
            viewSource: "Ver código fonte"
        },
        contact: {
            title: "Contato e Feedback",
            subtitle: "Dúvidas, sugestões ou bugs? Nos conte!",
            name: "Nome",
            callsign: "Indicativo (opcional)",
            email: "Email",
            type: "Tipo",
            typeFeedback: "Feedback geral",
            typeBug: "Relatar bug",
            typeFeature: "Solicitar recurso",
            typeContact: "Contato",
            message: "Mensagem",
            send: "Enviar",
            direct: "Contato direto",
            directDesc: "Para assuntos urgentes ou colaborações",
            issues: "Relatar problemas",
            issuesDesc: "Abra uma issue no GitHub"
        }
    },
    it: {
        lang: "Italiano",
        flag: "🇮🇹",
        nav: {
            features: "Funzionalità",
            screenshots: "Anteprima",
            download: "Scarica",
            about: "Info",
            contact: "Contatto"
        },
        hero: {
            badge: "Versione 0.14.0 disponibile",
            title1: "Programma la tua radio DMR",
            title2: "facilmente",
            description: "Ndmr è un software moderno e gratuito per creare e modificare i tuoi codeplug DMR. Multipiattaforma, intuitivo, progettato per radioamatori principianti ed esperti.",
            download: "Scarica",
            github: "Vedi su GitHub",
            platforms: "Disponibile su"
        },
        features: {
            title: "Tutto ciò di cui hai bisogno",
            subtitle: "Ndmr riunisce tutti gli strumenti per programmare la tua radio DMR in modo efficiente",
            multiplatform: {
                title: "Multipiattaforma",
                desc: "Windows, macOS, Linux, Android e iOS. Usa Ndmr su tutti i tuoi dispositivi."
            },
            intuitive: {
                title: "Interfaccia intuitiva",
                desc: "Progettata per i principianti con tooltip esplicativi per ogni parametro DMR."
            },
            repeaterbook: {
                title: "Importa Repeaterbook",
                desc: "Importa i ripetitori DMR direttamente da Repeaterbook.com in pochi clic."
            },
            export: {
                title: "Esportazione multiformato",
                desc: "Esporta in CSV, PDF o formato nativo. Compatibile con i file qdmr (.yaml)."
            },
            validation: {
                title: "Validazione intelligente",
                desc: "Rilevamento automatico di errori e incongruenze prima dell'esportazione sulla radio."
            },
            themes: {
                title: "Temi chiaro/scuro",
                desc: "Interfaccia adattiva con tema automatico basato sulle preferenze di sistema."
            }
        },
        screenshots: {
            title: "Scopri l'interfaccia",
            subtitle: "Un'interfaccia moderna e pulita per un'esperienza utente ottimale",
            dashboard: {
                title: "Dashboard",
                desc: "Panoramica del tuo codeplug con statistiche"
            },
            channels: {
                title: "Gestione canali",
                desc: "Crea e organizza i tuoi canali DMR facilmente"
            },
            zones: {
                title: "Organizzazione per zone",
                desc: "Raggruppa i tuoi canali per zona geografica"
            }
        },
        radios: {
            title: "Radio supportate",
            subtitle: "Ndmr supporta le radio DMR più popolari",
            supported: "Supportato",
            coming: "Prossimamente",
            anytone: {
                title: "Anytone AT-D878UV",
                desc: "Supporto completo con tutte le funzionalità"
            },
            opengd77: {
                title: "OpenGD77 / OpenRTX",
                desc: "Supporto previsto per firmware open-source"
            },
            tyt: {
                title: "TYT MD-UV380/390",
                desc: "Supporto previsto in una versione futura"
            },
            radioddity: {
                title: "Radioddity GD-77",
                desc: "Supporto previsto in una versione futura"
            }
        },
        download: {
            title: "Pronto a programmare la tua radio?",
            subtitle: "Scarica Ndmr gratuitamente e inizia a creare il tuo codeplug in pochi minuti.",
            for: "Scarica per",
            note: "Gratuito e open-source",
            allVersions: "Vedi tutte le versioni"
        },
        footer: {
            tagline: "Programmazione DMR semplificata per tutti i radioamatori.",
            resources: "Risorse",
            sourceCode: "Codice sorgente",
            versions: "Versioni",
            reportBug: "Segnala un bug",
            community: "Comunità",
            copyright: "Open-source sotto licenza MIT.",
            inspired: "Ispirato da"
        },
        about: {
            title: "Info",
            subtitle: "Il progetto e il suo autore",
            developer: "Sviluppato da",
            description: "Radioamatore e sviluppatore software, appassionato di DMR e tecnologie open-source.",
            openSource: "Open Source",
            license: "Ndmr è software libero rilasciato sotto licenza MIT. Il codice sorgente è disponibile su GitHub.",
            viewSource: "Vedi codice sorgente"
        },
        contact: {
            title: "Contatto e Feedback",
            subtitle: "Domande, suggerimenti o bug? Facci sapere!",
            name: "Nome",
            callsign: "Nominativo (opzionale)",
            email: "Email",
            type: "Tipo",
            typeFeedback: "Feedback generale",
            typeBug: "Segnalazione bug",
            typeFeature: "Richiesta funzionalità",
            typeContact: "Contatto",
            message: "Messaggio",
            send: "Invia",
            direct: "Contatto diretto",
            directDesc: "Per questioni urgenti o collaborazioni",
            issues: "Segnala problemi",
            issuesDesc: "Apri una issue su GitHub"
        }
    },
    de: {
        lang: "Deutsch",
        flag: "🇩🇪",
        nav: {
            features: "Funktionen",
            screenshots: "Vorschau",
            download: "Herunterladen",
            about: "Über",
            contact: "Kontakt"
        },
        hero: {
            badge: "Version 0.14.0 verfügbar",
            title1: "Programmieren Sie Ihr DMR-Funkgerät",
            title2: "einfach",
            description: "Ndmr ist eine moderne, kostenlose Software zum Erstellen und Bearbeiten Ihrer DMR-Codeplugs. Plattformübergreifend, intuitiv, für Anfänger und erfahrene Funkamateure konzipiert.",
            download: "Herunterladen",
            github: "Auf GitHub ansehen",
            platforms: "Verfügbar auf"
        },
        features: {
            title: "Alles was Sie brauchen",
            subtitle: "Ndmr vereint alle Werkzeuge, um Ihr DMR-Funkgerät effizient zu programmieren",
            multiplatform: {
                title: "Plattformübergreifend",
                desc: "Windows, macOS, Linux, Android und iOS. Nutzen Sie Ndmr auf all Ihren Geräten."
            },
            intuitive: {
                title: "Intuitive Oberfläche",
                desc: "Für Anfänger konzipiert mit erklärenden Tooltips für jeden DMR-Parameter."
            },
            repeaterbook: {
                title: "Repeaterbook-Import",
                desc: "Importieren Sie DMR-Repeater direkt von Repeaterbook.com mit wenigen Klicks."
            },
            export: {
                title: "Multi-Format-Export",
                desc: "Export nach CSV, PDF oder nativem Format. Kompatibel mit qdmr-Dateien (.yaml)."
            },
            validation: {
                title: "Intelligente Validierung",
                desc: "Automatische Erkennung von Fehlern und Inkonsistenzen vor dem Export zum Funkgerät."
            },
            themes: {
                title: "Hell/Dunkel-Themen",
                desc: "Adaptive Oberfläche mit automatischem Thema basierend auf Ihren Systemeinstellungen."
            }
        },
        screenshots: {
            title: "Entdecken Sie die Oberfläche",
            subtitle: "Eine moderne und übersichtliche Oberfläche für optimale Benutzererfahrung",
            dashboard: {
                title: "Dashboard",
                desc: "Übersicht Ihres Codeplugs mit Statistiken"
            },
            channels: {
                title: "Kanalverwaltung",
                desc: "Erstellen und organisieren Sie Ihre DMR-Kanäle einfach"
            },
            zones: {
                title: "Zonenorganisation",
                desc: "Gruppieren Sie Ihre Kanäle nach geografischer Zone"
            }
        },
        radios: {
            title: "Unterstützte Funkgeräte",
            subtitle: "Ndmr unterstützt die beliebtesten DMR-Funkgeräte",
            supported: "Unterstützt",
            coming: "Demnächst",
            anytone: {
                title: "Anytone AT-D878UV",
                desc: "Volle Unterstützung mit allen Funktionen"
            },
            opengd77: {
                title: "OpenGD77 / OpenRTX",
                desc: "Unterstützung für Open-Source-Firmware geplant"
            },
            tyt: {
                title: "TYT MD-UV380/390",
                desc: "Unterstützung in einer zukünftigen Version geplant"
            },
            radioddity: {
                title: "Radioddity GD-77",
                desc: "Unterstützung in einer zukünftigen Version geplant"
            }
        },
        download: {
            title: "Bereit, Ihr Funkgerät zu programmieren?",
            subtitle: "Laden Sie Ndmr kostenlos herunter und beginnen Sie in Minuten mit der Erstellung Ihres Codeplugs.",
            for: "Herunterladen für",
            note: "Kostenlos und Open-Source",
            allVersions: "Alle Versionen anzeigen"
        },
        footer: {
            tagline: "Vereinfachte DMR-Programmierung für alle Funkamateure.",
            resources: "Ressourcen",
            sourceCode: "Quellcode",
            versions: "Versionen",
            reportBug: "Fehler melden",
            community: "Community",
            copyright: "Open-Source unter MIT-Lizenz.",
            inspired: "Inspiriert von"
        },
        about: {
            title: "Über",
            subtitle: "Das Projekt und sein Autor",
            developer: "Entwickelt von",
            description: "Funkamateur und Softwareentwickler, begeistert von DMR und Open-Source-Technologien.",
            openSource: "Open Source",
            license: "Ndmr ist freie Software unter der MIT-Lizenz. Der Quellcode ist auf GitHub verfügbar.",
            viewSource: "Quellcode ansehen"
        },
        contact: {
            title: "Kontakt & Feedback",
            subtitle: "Fragen, Vorschläge oder Fehler? Lassen Sie es uns wissen!",
            name: "Name",
            callsign: "Rufzeichen (optional)",
            email: "E-Mail",
            type: "Typ",
            typeFeedback: "Allgemeines Feedback",
            typeBug: "Fehlerbericht",
            typeFeature: "Funktionsanfrage",
            typeContact: "Kontakt",
            message: "Nachricht",
            send: "Senden",
            direct: "Direkter Kontakt",
            directDesc: "Für dringende Angelegenheiten oder Zusammenarbeit",
            issues: "Probleme melden",
            issuesDesc: "Öffnen Sie ein Issue auf GitHub"
        }
    },
    uk: {
        lang: "Українська",
        flag: "🇺🇦",
        nav: {
            features: "Функції",
            screenshots: "Попередній перегляд",
            download: "Завантажити",
            about: "Про нас",
            contact: "Контакт"
        },
        hero: {
            badge: "Версія 0.14.0 доступна",
            title1: "Програмуйте свою DMR радіо",
            title2: "просто",
            description: "Ndmr — це сучасне безкоштовне програмне забезпечення для створення та редагування ваших DMR кодеплагів. Кросплатформне, інтуїтивне, розроблене для початківців і досвідчених радіоаматорів.",
            download: "Завантажити",
            github: "Переглянути на GitHub",
            platforms: "Доступно на"
        },
        features: {
            title: "Все, що вам потрібно",
            subtitle: "Ndmr об'єднує всі інструменти для ефективного програмування вашої DMR радіо",
            multiplatform: {
                title: "Кросплатформність",
                desc: "Windows, macOS, Linux, Android та iOS. Використовуйте Ndmr на всіх своїх пристроях."
            },
            intuitive: {
                title: "Інтуїтивний інтерфейс",
                desc: "Розроблено для початківців з пояснювальними підказками для кожного параметра DMR."
            },
            repeaterbook: {
                title: "Імпорт Repeaterbook",
                desc: "Імпортуйте DMR ретранслятори безпосередньо з Repeaterbook.com за кілька кліків."
            },
            export: {
                title: "Багатоформатний експорт",
                desc: "Експортуйте в CSV, PDF або рідний формат. Сумісний з файлами qdmr (.yaml)."
            },
            validation: {
                title: "Розумна валідація",
                desc: "Автоматичне виявлення помилок та невідповідностей перед експортом на радіо."
            },
            themes: {
                title: "Світла/темна теми",
                desc: "Адаптивний інтерфейс з автоматичною темою на основі системних налаштувань."
            }
        },
        screenshots: {
            title: "Відкрийте для себе інтерфейс",
            subtitle: "Сучасний та чистий інтерфейс для оптимального користувацького досвіду",
            dashboard: {
                title: "Панель керування",
                desc: "Огляд вашого кодеплага зі статистикою"
            },
            channels: {
                title: "Управління каналами",
                desc: "Легко створюйте та організовуйте свої DMR канали"
            },
            zones: {
                title: "Організація за зонами",
                desc: "Групуйте свої канали за географічною зоною"
            }
        },
        radios: {
            title: "Підтримувані радіо",
            subtitle: "Ndmr підтримує найпопулярніші DMR радіо",
            supported: "Підтримується",
            coming: "Незабаром",
            anytone: {
                title: "Anytone AT-D878UV",
                desc: "Повна підтримка з усіма функціями"
            },
            opengd77: {
                title: "OpenGD77 / OpenRTX",
                desc: "Підтримка запланована для прошивок з відкритим кодом"
            },
            tyt: {
                title: "TYT MD-UV380/390",
                desc: "Підтримка запланована в майбутній версії"
            },
            radioddity: {
                title: "Radioddity GD-77",
                desc: "Підтримка запланована в майбутній версії"
            }
        },
        download: {
            title: "Готові програмувати свою радіо?",
            subtitle: "Завантажте Ndmr безкоштовно та почніть створювати свій кодеплаг за лічені хвилини.",
            for: "Завантажити для",
            note: "Безкоштовно та з відкритим кодом",
            allVersions: "Переглянути всі версії"
        },
        footer: {
            tagline: "Спрощене програмування DMR для всіх радіоаматорів.",
            resources: "Ресурси",
            sourceCode: "Вихідний код",
            versions: "Версії",
            reportBug: "Повідомити про помилку",
            community: "Спільнота",
            copyright: "Відкритий код під ліцензією MIT.",
            inspired: "Натхненний"
        },
        about: {
            title: "Про нас",
            subtitle: "Проект та його автор",
            developer: "Розроблено",
            description: "Радіоаматор та розробник програмного забезпечення, захоплений DMR та технологіями з відкритим кодом.",
            openSource: "Відкритий код",
            license: "Ndmr — це вільне програмне забезпечення під ліцензією MIT. Вихідний код доступний на GitHub.",
            viewSource: "Переглянути вихідний код"
        },
        contact: {
            title: "Контакт і Відгук",
            subtitle: "Питання, пропозиції або помилки? Повідомте нас!",
            name: "Ім'я",
            callsign: "Позивний (необов'язково)",
            email: "Електронна пошта",
            type: "Тип",
            typeFeedback: "Загальний відгук",
            typeBug: "Звіт про помилку",
            typeFeature: "Запит на функцію",
            typeContact: "Контакт",
            message: "Повідомлення",
            send: "Надіслати",
            direct: "Прямий контакт",
            directDesc: "Для термінових питань або співпраці",
            issues: "Повідомити про проблеми",
            issuesDesc: "Відкрийте issue на GitHub"
        }
    }
};

// Supported languages
const supportedLanguages = ['fr', 'en', 'es', 'pt', 'it', 'de', 'uk'];

// Get user's preferred language
function detectLanguage() {
    // Check URL parameter first
    const urlParams = new URLSearchParams(window.location.search);
    const urlLang = urlParams.get('lang');
    if (urlLang && supportedLanguages.includes(urlLang)) {
        return urlLang;
    }

    // Check localStorage
    const savedLang = localStorage.getItem('ndmr-lang');
    if (savedLang && supportedLanguages.includes(savedLang)) {
        return savedLang;
    }

    // Detect from browser
    const browserLang = navigator.language.split('-')[0];
    if (supportedLanguages.includes(browserLang)) {
        return browserLang;
    }

    // Default to English
    return 'en';
}

// Get nested translation
function t(key) {
    const keys = key.split('.');
    let value = translations[currentLang];
    for (const k of keys) {
        if (value && value[k]) {
            value = value[k];
        } else {
            // Fallback to English
            value = translations['en'];
            for (const k2 of keys) {
                if (value && value[k2]) {
                    value = value[k2];
                } else {
                    return key;
                }
            }
        }
    }
    return value;
}

// Current language
let currentLang = detectLanguage();

// Apply translations to the page
function applyTranslations() {
    document.documentElement.lang = currentLang;

    // Update all elements with data-i18n attribute
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        el.textContent = t(key);
    });

    // Update elements with data-i18n-placeholder
    document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
        const key = el.getAttribute('data-i18n-placeholder');
        el.placeholder = t(key);
    });

    // Update current language in selector
    const langBtn = document.querySelector('.lang-current');
    if (langBtn) {
        langBtn.textContent = translations[currentLang].flag + ' ' + translations[currentLang].lang;
    }
}

// Change language
function setLanguage(lang) {
    if (supportedLanguages.includes(lang)) {
        currentLang = lang;
        localStorage.setItem('ndmr-lang', lang);
        applyTranslations();

        // Update URL without reload
        const url = new URL(window.location);
        url.searchParams.set('lang', lang);
        window.history.replaceState({}, '', url);
    }
}

// Create language selector using DOM methods (safe)
function createLanguageSelector() {
    const nav = document.querySelector('.nav-links');
    if (!nav) return;

    const selector = document.createElement('div');
    selector.className = 'lang-selector';

    // Create current language button
    const currentBtn = document.createElement('button');
    currentBtn.className = 'lang-current';
    currentBtn.textContent = translations[currentLang].flag + ' ' + translations[currentLang].lang;
    selector.appendChild(currentBtn);

    // Create dropdown
    const dropdown = document.createElement('div');
    dropdown.className = 'lang-dropdown';

    supportedLanguages.forEach(lang => {
        const option = document.createElement('button');
        option.className = 'lang-option' + (lang === currentLang ? ' active' : '');
        option.dataset.lang = lang;
        option.textContent = translations[lang].flag + ' ' + translations[lang].lang;

        option.addEventListener('click', () => {
            setLanguage(lang);
            selector.classList.remove('open');

            // Update active class
            dropdown.querySelectorAll('.lang-option').forEach(b => b.classList.remove('active'));
            option.classList.add('active');
        });

        dropdown.appendChild(option);
    });

    selector.appendChild(dropdown);

    // Insert before GitHub link
    const githubLink = nav.querySelector('.nav-github');
    nav.insertBefore(selector, githubLink);

    // Toggle dropdown
    currentBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        selector.classList.toggle('open');
    });

    // Close on outside click
    document.addEventListener('click', () => {
        selector.classList.remove('open');
    });
}

// Initialize i18n
document.addEventListener('DOMContentLoaded', () => {
    createLanguageSelector();
    applyTranslations();
});

// Export for use in other scripts
window.i18n = {
    t,
    setLanguage,
    currentLang: () => currentLang,
    supportedLanguages
};
