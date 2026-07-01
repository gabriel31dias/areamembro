class Theme < ApplicationRecord
  belongs_to :user
  has_one_attached :logo

  # Cores padrão da área de membros
  DEFAULTS = {
    primary_color:    "#6366f1",
    secondary_color:  "#a855f7",
    background_color: "#070a13",
    surface_color:    "#0e1424", # cards / sidebar
    text_color:       "#f9fafb",
    muted_text_color: "#9ca3af"
  }.freeze

  COLOR_FIELDS = DEFAULTS.keys.freeze

  DEFAULT_TITLE = "CATÁLOGO OFICIAL ALURADEV".freeze
  DEFAULT_PRIMARY_DESCRIPTION = "Aprenda no seu ritmo. Evolua com prática.".freeze
  DEFAULT_SECONDARY_DESCRIPTION = "Consulte abaixo somente os cursos disponíveis para sua conta, carregados diretamente da plataforma.".freeze

  DEFAULT_LOGIN_TITLE = "Bem-vindo de volta".freeze
  DEFAULT_LOGIN_SUBTITLE = "Entre com suas credenciais para continuar seus estudos.".freeze

  DEFAULT_HERO_TITLE = "Conhecimento técnico para".freeze
  DEFAULT_HERO_HIGHLIGHT = "construir o futuro.".freeze
  DEFAULT_HERO_SUBTITLE = "Acesse trilhas práticas, acompanhe sua evolução e transforme cada aula em progresso real para sua carreira.".freeze

  # Temas prontos (paletas harmônicas) para aplicar com 1 clique
  PRESETS = [
    # --- Masculinos (tons escuros e frios) ---
    {
      name: "Meia-Noite", gender: "masculino",
      primary_color: "#3b82f6", secondary_color: "#1d4ed8",
      background_color: "#0a0f1e", surface_color: "#141b2e",
      text_color: "#e8edf7", muted_text_color: "#8b97ad"
    },
    {
      name: "Oceano", gender: "masculino",
      primary_color: "#38bdf8", secondary_color: "#0ea5e9",
      background_color: "#0b1016", surface_color: "#151c26",
      text_color: "#eef4f9", muted_text_color: "#93a4b3"
    },
    {
      name: "Floresta", gender: "masculino",
      primary_color: "#10b981", secondary_color: "#059669",
      background_color: "#07120d", surface_color: "#0f1f17",
      text_color: "#eafaf2", muted_text_color: "#8fae9f"
    },
    # --- Femininos (tons quentes e elegantes) ---
    {
      name: "Rosé", gender: "feminino",
      primary_color: "#ec4899", secondary_color: "#db2777",
      background_color: "#fff5f8", surface_color: "#ffffff",
      text_color: "#4a1130", muted_text_color: "#9b6b80"
    },
    {
      name: "Lavanda", gender: "feminino",
      primary_color: "#a855f7", secondary_color: "#7c3aed",
      background_color: "#f8f5ff", surface_color: "#ffffff",
      text_color: "#3b1d5e", muted_text_color: "#8b7ba6"
    },
    {
      name: "Pêssego", gender: "feminino",
      primary_color: "#fb7185", secondary_color: "#f59e0b",
      background_color: "#fff8f1", surface_color: "#ffffff",
      text_color: "#4a2410", muted_text_color: "#a17d63"
    },
    # --- Inspirados em designs conhecidos ---
    {
      name: "Dracula", gender: "design",
      primary_color: "#bd93f9", secondary_color: "#ff79c6",
      background_color: "#282a36", surface_color: "#343746",
      text_color: "#f8f8f2", muted_text_color: "#6272a4"
    },
    {
      name: "Nord", gender: "design",
      primary_color: "#5e81ac", secondary_color: "#88c0d0",
      background_color: "#2e3440", surface_color: "#3b4252",
      text_color: "#eceff4", muted_text_color: "#9aa5b1"
    },
    {
      name: "Tokyo Night", gender: "design",
      primary_color: "#7aa2f7", secondary_color: "#bb9af7",
      background_color: "#1a1b26", surface_color: "#24283b",
      text_color: "#c0caf5", muted_text_color: "#9aa5ce"
    },
    {
      name: "GitHub Dark", gender: "design",
      primary_color: "#1f6feb", secondary_color: "#58a6ff",
      background_color: "#0d1117", surface_color: "#161b22",
      text_color: "#c9d1d9", muted_text_color: "#8b949e"
    },
    {
      name: "Spotify", gender: "design",
      primary_color: "#1db954", secondary_color: "#1ed760",
      background_color: "#121212", surface_color: "#181818",
      text_color: "#ffffff", muted_text_color: "#b3b3b3"
    },
    {
      name: "Discord", gender: "design",
      primary_color: "#5865f2", secondary_color: "#404eed",
      background_color: "#313338", surface_color: "#2b2d31",
      text_color: "#f2f3f5", muted_text_color: "#b5bac1"
    },
    {
      name: "Stripe", gender: "design",
      primary_color: "#635bff", secondary_color: "#00d4ff",
      background_color: "#f6f9fc", surface_color: "#ffffff",
      text_color: "#0a2540", muted_text_color: "#425466"
    },
    {
      name: "Material", gender: "design",
      primary_color: "#3f51b5", secondary_color: "#ff4081",
      background_color: "#fafafa", surface_color: "#ffffff",
      text_color: "#212121", muted_text_color: "#757575"
    }
  ].freeze

  HEX_COLOR = /\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/

  validates(*COLOR_FIELDS,
            format: { with: HEX_COLOR, message: "deve ser uma cor hexadecimal válida (ex: #00d4ff)" })

  after_initialize :apply_defaults
  before_validation :apply_defaults
  validate :acceptable_logo

  # Hash com todas as cores (útil para a API)
  def colors
    COLOR_FIELDS.index_with { |field| public_send(field) }
  end

  # Caminho (relativo) do logo enviado, ou nil
  def logo_url
    return nil unless logo.attached?
    Rails.application.routes.url_helpers.rails_blob_url(logo, only_path: true)
  end

  private

  def apply_defaults
    DEFAULTS.each do |field, value|
      public_send("#{field}=", value) if public_send(field).blank?
    end
    self.member_area_title = DEFAULT_TITLE if member_area_title.blank?
    self.primary_description = DEFAULT_PRIMARY_DESCRIPTION if primary_description.blank?
    self.secondary_description = DEFAULT_SECONDARY_DESCRIPTION if secondary_description.blank?
    self.login_title = DEFAULT_LOGIN_TITLE if login_title.blank?
    self.login_subtitle = DEFAULT_LOGIN_SUBTITLE if login_subtitle.blank?
    self.hero_title = DEFAULT_HERO_TITLE if hero_title.blank?
    self.hero_highlight = DEFAULT_HERO_HIGHLIGHT if hero_highlight.blank?
    self.hero_subtitle = DEFAULT_HERO_SUBTITLE if hero_subtitle.blank?
  end

  def acceptable_logo
    return unless logo.attached?

    unless logo.content_type.in?(%w[image/png image/jpeg image/webp image/svg+xml])
      errors.add(:logo, "deve ser uma imagem (PNG, JPG, WEBP ou SVG)")
    end

    if logo.byte_size > 5.megabytes
      errors.add(:logo, "deve ter no máximo 5MB")
    end
  end
end
