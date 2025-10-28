# Limpar dados anteriores (opcional - comente se não quiser limpar)
puts "Limpando dados anteriores..."
UserPlan.destroy_all
Sale.destroy_all
Plan.destroy_all

# Criar planos
puts "Criando planos..."

plan_basic = Plan.create!(
  name: 'Plano Básico',
  description: 'Acesso a cursos básicos',
  price: 49.90,
  duration_days: 30,
  active: true,
  features: [
    'Acesso a cursos básicos',
    'Suporte por email',
    'Certificado de conclusão'
  ]
)

plan_premium = Plan.create!(
  name: 'Plano Premium',
  description: 'Acesso completo a todos os cursos',
  price: 99.90,
  duration_days: 30,
  active: true,
  features: [
    'Acesso a todos os cursos',
    'Suporte prioritário',
    'Certificado de conclusão',
    'Aulas ao vivo mensais',
    'Material complementar'
  ]
)

plan_annual = Plan.create!(
  name: 'Plano Anual',
  description: 'Acesso completo por 1 ano com desconto',
  price: 999.00,
  duration_days: 365,
  active: true,
  features: [
    'Acesso a todos os cursos',
    'Suporte VIP 24/7',
    'Certificado de conclusão',
    'Aulas ao vivo semanais',
    'Material complementar',
    'Mentoria individual mensal',
    '3 meses grátis'
  ]
)

plan_trial = Plan.create!(
  name: 'Plano Trial',
  description: 'Teste grátis por 7 dias',
  price: 0.00,
  duration_days: 7,
  active: true,
  features: [
    'Acesso limitado a 3 cursos',
    'Suporte por email'
  ]
)

puts "✅ Planos criados com sucesso!"

# Buscar usuários existentes
admin = User.find_by(email: 'admin@example.com')
member = User.find_by(email: 'member@example.com')
member2 = User.find_by(email: 'joao@example.com')
member3 = User.find_by(email: 'maria@example.com')

# Criar vendas vinculadas a planos
puts "Criando vendas com planos..."

if member2
  # Venda completa - ativa o plano automaticamente
  sale1 = Sale.create!(
    user: member2,
    plan: plan_premium,
    amount: plan_premium.price,
    payment_method: 'credit_card',
    status: 'completed',
    notes: 'Assinatura Plano Premium - Outubro'
  )

  sale2 = Sale.create!(
    user: member2,
    plan: plan_premium,
    amount: plan_premium.price,
    payment_method: 'pix',
    status: 'completed',
    notes: 'Renovação Plano Premium - Novembro'
  )
end

if member
  # Venda pendente
  Sale.create!(
    user: member,
    plan: plan_basic,
    amount: plan_basic.price,
    payment_method: 'credit_card',
    status: 'pending',
    notes: 'Aguardando pagamento - Plano Básico'
  )
end

if member3
  # Venda trial completa
  Sale.create!(
    user: member3,
    plan: plan_trial,
    amount: plan_trial.price,
    payment_method: 'free',
    status: 'completed',
    notes: 'Trial gratuito'
  )
end

puts "✅ Vendas criadas com sucesso!"

# Verificar planos ativos dos usuários
puts "\n📊 Resumo dos Planos Ativos:"
User.members.each do |user|
  current_plan = user.current_plan
  if current_plan
    user_plan = user.user_plans.active.first
    puts "  - #{user.email}: #{current_plan.name} (expira em #{user_plan.expires_at.strftime('%d/%m/%Y')})"
  else
    puts "  - #{user.email}: Sem plano ativo"
  end
end

puts "\n✅ Seeds de planos executados com sucesso!"
puts "\nPlanos disponíveis:"
Plan.all.each do |plan|
  puts "  - #{plan.name}: R$ #{plan.price} (#{plan.duration_days} dias)"
end
