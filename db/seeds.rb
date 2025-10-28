# Criar usuários de exemplo
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'admin'
)

user = User.create!(
  email: 'user@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'user'
)

member = User.create!(
  email: 'member@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'member'
)

puts "✅ Usuários criados com sucesso!"

# Criar cursos de exemplo com imagens
require 'open-uri'

course1 = Course.create!(
  title: 'Ruby on Rails Fundamentals',
  description: 'Learn the basics of Ruby on Rails framework',
  total_lessons: 20,
  active: true
)
# Anexar imagem do placeholder
course1.photo.attach(
  io: URI.open('https://picsum.photos/seed/rails/800/600'),
  filename: 'rails-course.jpg',
  content_type: 'image/jpeg'
)

course2 = Course.create!(
  title: 'Advanced JavaScript',
  description: 'Master advanced JavaScript concepts and patterns',
  total_lessons: 15,
  active: true
)
course2.photo.attach(
  io: URI.open('https://picsum.photos/seed/javascript/800/600'),
  filename: 'javascript-course.jpg',
  content_type: 'image/jpeg'
)

course3 = Course.create!(
  title: 'React for Beginners',
  description: 'Build modern web applications with React',
  total_lessons: 25,
  active: true
)
course3.photo.attach(
  io: URI.open('https://picsum.photos/seed/react/800/600'),
  filename: 'react-course.jpg',
  content_type: 'image/jpeg'
)

puts "✅ Cursos criados com sucesso!"

# Criar progresso de exemplo para o membro
CourseProgress.create!(
  user: member,
  course: course1,
  completed_lessons: 10,
  last_accessed_at: 2.days.ago
)

CourseProgress.create!(
  user: member,
  course: course2,
  completed_lessons: 5,
  last_accessed_at: 1.day.ago
)

puts "✅ Progresso dos cursos criado com sucesso!"


# Criar aulas para os cursos
puts "Criando aulas..."

# Aulas para Ruby on Rails Fundamentals
[
  { title: 'Introdução ao Rails', description: 'Visão geral do framework', video_url: 'https://example.com/video1.mp4', order_number: 1, duration_minutes: 15 },
  { title: 'MVC Pattern', description: 'Entendendo Model-View-Controller', video_url: 'https://example.com/video2.mp4', order_number: 2, duration_minutes: 20 },
  { title: 'Active Record Basics', description: 'Trabalhando com banco de dados', video_url: 'https://example.com/video3.mp4', order_number: 3, duration_minutes: 25 },
  { title: 'Routing', description: 'Configurando rotas', video_url: 'https://example.com/video4.mp4', order_number: 4, duration_minutes: 18 },
  { title: 'Controllers', description: 'Criando controllers', video_url: 'https://example.com/video5.mp4', order_number: 5, duration_minutes: 22 }
].each do |lesson_data|
  course1.lessons.create!(lesson_data)
end

# Aulas para Advanced JavaScript
[
  { title: 'Closures', description: 'Entendendo closures em JavaScript', video_url: 'https://example.com/js1.mp4', order_number: 1, duration_minutes: 12 },
  { title: 'Promises', description: 'Programação assíncrona', video_url: 'https://example.com/js2.mp4', order_number: 2, duration_minutes: 18 },
  { title: 'Async/Await', description: 'Sintaxe moderna para async', video_url: 'https://example.com/js3.mp4', order_number: 3, duration_minutes: 15 }
].each do |lesson_data|
  course2.lessons.create!(lesson_data)
end

# Aulas para React for Beginners
[
  { title: 'React Basics', description: 'Introdução ao React', video_url: 'https://example.com/react1.mp4', order_number: 1, duration_minutes: 20 },
  { title: 'Components', description: 'Criando componentes', video_url: 'https://example.com/react2.mp4', order_number: 2, duration_minutes: 25 },
  { title: 'State & Props', description: 'Gerenciando estado', video_url: 'https://example.com/react3.mp4', order_number: 3, duration_minutes: 30 },
  { title: 'Hooks', description: 'useState e useEffect', video_url: 'https://example.com/react4.mp4', order_number: 4, duration_minutes: 28 }
].each do |lesson_data|
  course3.lessons.create!(lesson_data)
end

# Atualizar total_lessons dos cursos
course1.update(total_lessons: course1.lessons.count)
course2.update(total_lessons: course2.lessons.count)
course3.update(total_lessons: course3.lessons.count)

puts "✅ Aulas criadas com sucesso!"

# Criar progresso de aulas para o membro
puts "Criando progresso de aulas..."

# Marcar algumas aulas como completas
LessonProgress.create!(
  user: member,
  lesson: course1.lessons.first,
  completed: true,
  watched_seconds: 900,
  completed_at: 3.days.ago
)

LessonProgress.create!(
  user: member,
  lesson: course1.lessons.second,
  completed: true,
  watched_seconds: 1200,
  completed_at: 2.days.ago
)

LessonProgress.create!(
  user: member,
  lesson: course1.lessons.third,
  completed: false,
  watched_seconds: 450
)

puts "✅ Progresso de aulas criado com sucesso!"


# Atualizar usuários com novos campos
puts "Atualizando usuários..."

admin.update(name: 'Admin User', status: 'active', subscription_status: 'free')
user.update(name: 'Regular User', status: 'active', subscription_status: 'free')
member.update(name: 'Member User', status: 'active', subscription_status: 'free')

# Criar mais alguns membros
member2 = User.create!(
  name: 'João Silva',
  email: 'joao@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'member',
  status: 'active',
  subscription_status: 'subscriber'
)

member3 = User.create!(
  name: 'Maria Santos',
  email: 'maria@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'member',
  status: 'blocked',
  subscription_status: 'free',
  blocked_at: 1.day.ago
)

puts "✅ Usuários atualizados!"

# Criar vendas de exemplo
puts "Criando vendas..."

Sale.create!(
  user: member2,
  amount: 149.90,
  payment_method: 'credit_card',
  status: 'completed',
  notes: 'Assinatura mensal - Outubro'
)

Sale.create!(
  user: member2,
  amount: 149.90,
  payment_method: 'pix',
  status: 'completed',
  notes: 'Renovação - Novembro'
)

Sale.create!(
  user: member,
  amount: 149.90,
  payment_method: 'credit_card',
  status: 'pending',
  notes: 'Aguardando pagamento'
)

puts "✅ Vendas criadas com sucesso!"
