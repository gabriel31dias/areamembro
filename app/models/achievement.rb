# Catálogo de conquistas (não é uma tabela; os desbloqueios ficam em UserAchievement).
class Achievement
  CATALOG = {
    "first_step" => {
      name: "Primeiro Passo",
      description: "Assista à sua primeira aula",
      icon: "👣"
    },
    "quiz_master" => {
      name: "Mestre dos Testes",
      description: "Passe pela primeira vez em um quiz",
      icon: "🧠"
    },
    "graduate" => {
      name: "Diplomado",
      description: "Emita seu primeiro certificado",
      icon: "🎓"
    },
    "marathoner" => {
      name: "Maratonista",
      description: "Assista a cinco aulas",
      icon: "🏃"
    },
    "premium_subscriber" => {
      name: "Assinante Premium",
      description: "Assine um plano da plataforma",
      icon: "⭐"
    }
  }.freeze

  KEYS = CATALOG.keys.freeze

  # Desbloqueia uma conquista para o usuário (idempotente).
  # Retorna o UserAchievement criado, ou nil se já estava desbloqueada/chave inválida.
  def self.unlock(user, key)
    key = key.to_s
    return nil unless CATALOG.key?(key)
    return nil if user.user_achievements.exists?(achievement_key: key)

    achievement = user.user_achievements.create!(achievement_key: key)

    info = CATALOG[key]
    Activity.track(user, :achievement_unlocked,
      title: "Conquista desbloqueada",
      description: "Você desbloqueou: #{info[:name]}",
      metadata: { achievement_key: key, name: info[:name], icon: info[:icon] })

    achievement
  end

  # Avalia as conquistas relacionadas a aulas assistidas.
  def self.evaluate_lessons!(user)
    watched = LessonProgress.where(user_id: user.id)
                            .where("watched_seconds > 0 OR completed = ?", true)
                            .count
    unlock(user, :first_step) if watched >= 1

    completed = LessonProgress.where(user_id: user.id, completed: true).count
    unlock(user, :marathoner) if completed >= 5
  end
end
