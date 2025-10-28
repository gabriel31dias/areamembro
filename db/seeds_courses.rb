# Seeds para testar paginação infinita - 100 cursos

puts "🚀 Criando 100 cursos para teste de paginação..."

course_titles = [
  "Introdução ao Ruby on Rails",
  "JavaScript Avançado",
  "React do Zero ao Avançado",
  "Node.js e Express",
  "Python para Data Science",
  "Machine Learning Básico",
  "Docker e Kubernetes",
  "AWS Cloud Practitioner",
  "Git e GitHub Completo",
  "SQL e Banco de Dados",
  "MongoDB e NoSQL",
  "Vue.js 3 Completo",
  "Angular Moderno",
  "TypeScript na Prática",
  "GraphQL API",
  "REST API Design",
  "Microservices Architecture",
  "DevOps Essentials",
  "CI/CD com GitHub Actions",
  "Testes Automatizados",
  "TDD na Prática",
  "Clean Code",
  "Design Patterns",
  "SOLID Principles",
  "Arquitetura de Software",
  "DDD - Domain Driven Design",
  "Scrum e Metodologias Ágeis",
  "Product Management",
  "UX/UI Design",
  "Figma Completo",
  "HTML5 e CSS3",
  "Tailwind CSS",
  "Bootstrap 5",
  "SASS e SCSS",
  "Webpack e Bundlers",
  "Vite.js",
  "Next.js 14",
  "Nuxt.js 3",
  "Gatsby",
  "Remix",
  "Svelte e SvelteKit",
  "Flutter Mobile",
  "React Native",
  "Ionic Framework",
  "Swift iOS",
  "Kotlin Android",
  "Unity Game Development",
  "Unreal Engine",
  "Blender 3D",
  "Photoshop CC",
  "Illustrator",
  "After Effects",
  "Premiere Pro",
  "DaVinci Resolve",
  "Marketing Digital",
  "SEO Avançado",
  "Google Ads",
  "Facebook Ads",
  "Instagram Marketing",
  "TikTok para Negócios",
  "Email Marketing",
  "Copywriting",
  "Growth Hacking",
  "Analytics e Métricas",
  "Power BI",
  "Tableau",
  "Excel Avançado",
  "Google Sheets",
  "Notion Produtividade",
  "Trello e Gestão",
  "Slack para Teams",
  "Zoom Meetings",
  "OBS Studio",
  "Streaming na Twitch",
  "YouTube Creator",
  "Podcast Production",
  "Audio Engineering",
  "Music Production",
  "Ableton Live",
  "FL Studio",
  "Logic Pro X",
  "Pro Tools",
  "Fotografia Digital",
  "Lightroom",
  "Capture One",
  "Edição de Fotos",
  "Fotografia de Produto",
  "Fotografia de Retrato",
  "Fotografia de Paisagem",
  "Drone Photography",
  "Video Marketing",
  "Storytelling",
  "Roteiro para Vídeo",
  "Direção de Fotografia",
  "Produção Audiovisual",
  "Motion Graphics",
  "3D Animation",
  "Character Design",
  "Concept Art"
]

descriptions = [
  "Aprenda do zero ao avançado com projetos práticos e reais.",
  "Domine as técnicas mais modernas e requisitadas do mercado.",
  "Curso completo com certificado e suporte vitalício.",
  "Mais de 50 horas de conteúdo atualizado.",
  "Projetos práticos para seu portfólio profissional.",
  "Metodologia comprovada com milhares de alunos.",
  "Do básico ao avançado em um único curso.",
  "Aprenda com especialistas da indústria.",
  "Conteúdo atualizado constantemente.",
  "Exercícios práticos e desafios reais."
]

100.times do |i|
  title = course_titles[i] || "Curso #{i + 1}: #{course_titles.sample}"
  
  course = Course.create!(
    title: title,
    description: descriptions.sample,
    total_lessons: rand(10..50),
    active: [true, true, true, false].sample # 75% ativos
  )
  
  # Adicionar algumas aulas aleatórias
  rand(3..8).times do |j|
    course.lessons.create!(
      title: "Aula #{j + 1}: #{['Introdução', 'Conceitos', 'Prática', 'Projeto', 'Exercícios'].sample}",
      description: "Conteúdo da aula #{j + 1}",
      order_number: j + 1,
      duration_minutes: rand(10..60),
      video_url: "https://youtube.com/watch?v=example#{i}#{j}"
    )
  end
  
  # Atualizar total de aulas
  course.update(total_lessons: course.lessons.count)
  
  print "." if (i + 1) % 10 == 0
end

puts "\n✅ 100 cursos criados com sucesso!"
puts "📊 Total de cursos no banco: #{Course.count}"
puts "📚 Total de aulas criadas: #{Lesson.count}"
