# Documentação da API - Planos e Assinaturas

## Endpoints Públicos de Planos

### 1. Listar Planos Disponíveis

**Endpoint:** `GET /api/v1/plans`

**Descrição:** Lista todos os planos ativos disponíveis para assinatura

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/plans \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "plans": [
    {
      "id": 1,
      "name": "Plano Básico",
      "description": "Acesso a cursos básicos",
      "price": 49.90,
      "duration_days": 30,
      "features": [
        "Acesso a cursos básicos",
        "Suporte por email",
        "Certificado de conclusão"
      ]
    },
    {
      "id": 2,
      "name": "Plano Premium",
      "description": "Acesso completo a todos os cursos",
      "price": 99.90,
      "duration_days": 30,
      "features": [
        "Acesso a todos os cursos",
        "Suporte prioritário",
        "Certificado de conclusão",
        "Aulas ao vivo mensais",
        "Material complementar"
      ]
    },
    {
      "id": 3,
      "name": "Plano Anual",
      "description": "Acesso completo por 1 ano com desconto",
      "price": 999.00,
      "duration_days": 365,
      "features": [
        "Acesso a todos os cursos",
        "Suporte VIP 24/7",
        "Certificado de conclusão",
        "Aulas ao vivo semanais",
        "Material complementar",
        "Mentoria individual mensal",
        "3 meses grátis"
      ]
    }
  ]
}
```

---

## Endpoints de Administração de Planos (Admins)

### 1. Listar Todos os Planos (Admin)

**Endpoint:** `GET /api/v1/admin/plans`

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/admin/plans \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "plans": [
    {
      "id": 1,
      "name": "Plano Básico",
      "description": "Acesso a cursos básicos",
      "price": 49.90,
      "duration_days": 30,
      "active": true,
      "features": ["Acesso a cursos básicos", "Suporte por email"],
      "created_at": "2024-10-20T10:00:00.000Z"
    }
  ]
}
```

---

### 2. Ver Detalhes do Plano (Admin)

**Endpoint:** `GET /api/v1/admin/plans/:id`

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/admin/plans/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "plan": {
    "id": 1,
    "name": "Plano Básico",
    "description": "Acesso a cursos básicos",
    "price": 49.90,
    "duration_days": 30,
    "active": true,
    "features": ["Acesso a cursos básicos", "Suporte por email"],
    "created_at": "2024-10-20T10:00:00.000Z",
    "stats": {
      "active_subscriptions": 15,
      "total_subscriptions": 45,
      "total_revenue": 2245.50
    }
  }
}
```

---

### 3. Criar Plano (Admin)

**Endpoint:** `POST /api/v1/admin/plans`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/admin/plans \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Plano VIP",
    "description": "Acesso exclusivo com benefícios premium",
    "price": 199.90,
    "duration_days": 30,
    "active": true,
    "features": [
      "Acesso ilimitado",
      "Suporte 24/7",
      "Mentoria individual",
      "Certificados premium"
    ]
  }'
```

**Response Success (201):**
```json
{
  "message": "Plan created successfully",
  "plan": {
    "id": 5,
    "name": "Plano VIP",
    "description": "Acesso exclusivo com benefícios premium",
    "price": 199.90,
    "duration_days": 30,
    "active": true,
    "features": [
      "Acesso ilimitado",
      "Suporte 24/7",
      "Mentoria individual",
      "Certificados premium"
    ],
    "created_at": "2024-10-27T20:00:00.000Z"
  }
}
```

---

### 4. Atualizar Plano (Admin)

**Endpoint:** `PATCH /api/v1/admin/plans/:id`

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/plans/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "price": 59.90,
    "description": "Acesso a cursos básicos - Atualizado"
  }'
```

**Response Success (200):**
```json
{
  "message": "Plan updated successfully",
  "plan": {
    "id": 1,
    "name": "Plano Básico",
    "description": "Acesso a cursos básicos - Atualizado",
    "price": 59.90,
    "duration_days": 30,
    "active": true,
    "features": ["Acesso a cursos básicos", "Suporte por email"],
    "created_at": "2024-10-20T10:00:00.000Z"
  }
}
```

---

### 5. Deletar Plano (Admin)

**Endpoint:** `DELETE /api/v1/admin/plans/:id`

**Descrição:** Não permite deletar planos com assinaturas ativas

**Request:**
```bash
curl -X DELETE http://localhost:3000/api/v1/admin/plans/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "message": "Plan deleted successfully"
}
```

**Response Error (403):**
```json
{
  "error": "Cannot delete plan with active subscriptions"
}
```

---

## Fluxo de Venda com Plano

### 1. Criar Venda Vinculada a um Plano

**Endpoint:** `POST /api/v1/admin/sales`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/admin/sales \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 5,
    "plan_id": 2,
    "amount": 99.90,
    "payment_method": "credit_card",
    "status": "pending",
    "notes": "Assinatura Plano Premium"
  }'
```

**Response Success (201):**
```json
{
  "message": "Sale created successfully",
  "sale": {
    "id": 10,
    "user": {
      "id": 5,
      "name": "João Silva",
      "email": "joao@example.com",
      "subscription_status": "free"
    },
    "plan": {
      "id": 2,
      "name": "Plano Premium",
      "price": 99.90
    },
    "amount": 99.90,
    "payment_method": "credit_card",
    "status": "pending",
    "notes": "Assinatura Plano Premium",
    "created_at": "2024-10-27T20:30:00.000Z",
    "updated_at": "2024-10-27T20:30:00.000Z"
  }
}
```

---

### 2. Confirmar Pagamento (Ativa o Plano)

**Endpoint:** `PATCH /api/v1/admin/sales/:id`

**Descrição:** Quando status muda para "completed", o plano é automaticamente ativado para o usuário

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/sales/10 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "completed"
  }'
```

**Response Success (200):**
```json
{
  "message": "Sale updated successfully",
  "sale": {
    "id": 10,
    "user": {
      "id": 5,
      "name": "João Silva",
      "email": "joao@example.com",
      "subscription_status": "subscriber"
    },
    "plan": {
      "id": 2,
      "name": "Plano Premium",
      "price": 99.90
    },
    "amount": 99.90,
    "payment_method": "credit_card",
    "status": "completed",
    "notes": "Assinatura Plano Premium",
    "created_at": "2024-10-27T20:30:00.000Z",
    "updated_at": "2024-10-27T20:35:00.000Z"
  }
}
```

**Nota:** Após a confirmação, o usuário:
- Vira "subscriber"
- Recebe um UserPlan ativo vinculado ao plano
- O plano expira automaticamente após `duration_days`

---

## Ver Plano Ativo do Usuário

**Endpoint:** `GET /api/v1/admin/users/:id`

**Response inclui plano ativo:**
```json
{
  "user": {
    "id": 5,
    "name": "João Silva",
    "email": "joao@example.com",
    "role": "member",
    "status": "active",
    "subscription_status": "subscriber",
    "current_plan": {
      "id": 2,
      "name": "Plano Premium",
      "expires_at": "2024-11-27T20:35:00.000Z"
    },
    "stats": {
      "total_courses": 3,
      "completed_courses": 1,
      "total_sales": 99.90,
      "sales_count": 1
    }
  }
}
```

---

## Resumo do Fluxo

1. **Admin cria planos** → `POST /api/v1/admin/plans`
2. **Usuário vê planos disponíveis** → `GET /api/v1/plans`
3. **Admin cria venda com plano** → `POST /api/v1/admin/sales` (com `plan_id`)
4. **Admin confirma pagamento** → `PATCH /api/v1/admin/sales/:id` (status: completed)
5. **Sistema ativa plano automaticamente** → UserPlan criado, usuário vira subscriber
6. **Plano expira após duration_days** → Status muda para expired
