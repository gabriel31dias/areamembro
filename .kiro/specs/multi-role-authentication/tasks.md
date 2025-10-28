# Plano de Implementação

- [x] 1. Configurar estrutura base da API
  - Criar controlador base Api::BaseController
  - Configurar rotas API no routes.rb
  - _Requisitos: 4.4, 4.5_

- [x] 2. Implementar serviço JWT
  - Criar classe JwtService para geração e validação de tokens
  - Configurar secret key para JWT
  - _Requisitos: 1.2, 2.2, 3.2_

- [ ] 3. Criar modelos de usuário
  - Implementar modelos Admin, User e Member
  - Configurar validações e autenticação
  - _Requisitos: 1.2, 2.2, 3.2_

- [ ] 4. Implementar controlador de sessões para Admin
- [ ] 4.1 Criar Api::Admin::SessionsController
  - Implementar método create para login
  - Implementar método destroy para logout
  - _Requisitos: 1.1, 1.2, 1.3, 1.4, 5.1, 5.4, 5.5_

- [ ] 5. Implementar controlador de sessões para Users
- [ ] 5.1 Criar Api::Users::SessionsController
  - Implementar método create para login
  - Implementar método destroy para logout
  - _Requisitos: 2.1, 2.2, 2.3, 2.4, 5.2, 5.4, 5.5_

- [ ] 6. Implementar controlador de sessões para Members
- [ ] 6.1 Criar Api::Members::SessionsController
  - Implementar método create para login
  - Implementar método destroy para logout
  - _Requisitos: 3.1, 3.2, 3.3, 3.4, 5.3, 5.4, 5.5_

- [ ] 7. Configurar tratamento de erros
  - Implementar respostas JSON padronizadas
  - Configurar middleware de tratamento de exceções
  - _Requisitos: 1.3, 2.3, 3.3_