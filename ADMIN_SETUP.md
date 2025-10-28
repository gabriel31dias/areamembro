# Painel Admin - Guia de Configuração

## 🎯 O que foi criado

Um painel administrativo completo e responsivo usando Rails + Hotwire (Turbo) com design moderno e mobile-first.

## 📱 Características

### Design Responsivo
- **Desktop**: Layout com sidebar fixa e grid de cards
- **Tablet**: Grid adaptativo com 2 colunas
- **Mobile**: Grid de 1 coluna com menu hamburguer flutuante

### Funcionalidades

1. **Autenticação Admin**
   - Login exclusivo para admins
   - Sessão segura
   - Logout

2. **Dashboard**
   - Estatísticas gerais (usuários, membros, assinantes, vendas)
   - Vendas recentes
   - Usuários recentes
   - Cards com ícones coloridos

3. **Gestão de Usuários**
   - Listagem em grid responsivo
   - Filtros por role e status
   - Paginação (12 por página)
   - Criar novo usuário
   - Editar usuário
   - Ver detalhes completos
   - Bloquear/Desbloquear
   - Deletar usuário

4. **Detalhes do Usuário**
   - Informações completas
   - Plano ativo (se houver)
   - Estatísticas (cursos, vendas)
   - Histórico de vendas
   - Progresso nos cursos

## 🚀 Como usar

### 1. Rodar as migrações
```bash
rails db:migrate
rails db:seed
ruby db/seeds_plans.rb
```

### 2. Acessar o painel
```
http://localhost:3000/admin/login
```

### 3. Credenciais de teste
```
Email: admin@example.com
Senha: password123
```

## 📍 Rotas do Admin

```ruby
GET    /admin/login              # Página de login
POST   /admin/login              # Fazer login
DELETE /admin/logout             # Fazer logout
GET    /admin/dashboard          # Dashboard principal
GET    /admin                    # Redireciona para dashboard

# Usuários
GET    /admin/users              # Listar usuários
GET    /admin/users/new          # Formulário novo usuário
POST   /admin/users              # Criar usuário
GET    /admin/users/:id          # Ver detalhes
GET    /admin/users/:id/edit     # Formulário editar
PATCH  /admin/users/:id          # Atualizar usuário
DELETE /admin/users/:id          # Deletar usuário
PATCH  /admin/users/:id/block    # Bloquear usuário
PATCH  /admin/users/:id/unblock  # Desbloquear usuário
```

## 🎨 Design System

### Cores
- **Primary**: Gradiente roxo (#667eea → #764ba2)
- **Success**: Verde (#48bb78)
- **Danger**: Vermelho (#f56565)
- **Warning**: Amarelo (#d97706)
- **Info**: Azul (#4299e1)

### Badges
- `badge-success`: Verde (ativo, completo)
- `badge-danger`: Vermelho (bloqueado, cancelado)
- `badge-warning`: Amarelo (assinante, pendente)
- `badge-info`: Azul (roles, informações)

### Componentes
- **Cards**: Brancos com sombra suave, hover com elevação
- **Botões**: Gradiente primary, hover com elevação
- **Forms**: Inputs com borda, focus com sombra azul
- **Grid**: Responsivo com auto-fit

## 📱 Responsividade

### Desktop (> 768px)
- Sidebar fixa de 260px
- Grid de 3-4 colunas
- Todos os elementos visíveis

### Tablet (480px - 768px)
- Sidebar escondida (toggle com botão)
- Grid de 2 colunas
- Stats em 2 colunas

### Mobile (< 480px)
- Sidebar escondida (toggle com botão)
- Grid de 1 coluna
- Stats em 1 coluna
- Botão flutuante no canto inferior direito

## 🔒 Segurança

- Apenas usuários com `role: 'admin'` podem acessar
- Sessão armazenada com `session[:admin_user_id]`
- Proteção contra CSRF
- Admin não pode bloquear ou deletar a si mesmo

## 🎯 Próximos Passos

Para expandir o painel, você pode adicionar:

1. **Gestão de Cursos**
   - CRUD de cursos
   - Upload de fotos
   - Gestão de aulas

2. **Gestão de Vendas**
   - Criar vendas manualmente
   - Aprovar pagamentos
   - Relatórios

3. **Gestão de Planos**
   - CRUD de planos
   - Ativar/desativar planos

4. **Relatórios**
   - Gráficos de vendas
   - Estatísticas detalhadas
   - Exportação de dados

## 💡 Dicas

- Use Turbo para navegação sem reload
- Adicione Stimulus controllers para interatividade
- Customize os estilos no layout admin.html.erb
- Use flash messages para feedback ao usuário
