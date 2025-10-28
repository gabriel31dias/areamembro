#!/usr/bin/env ruby

# Script para atualizar cores do sistema
# De: #00b4d8 e #0077b6 (azul antigo)
# Para: #00d4ff e #0066ff (azul ciano novo)

files_to_update = [
  'app/views/layouts/panel.html.erb',
  'app/views/layouts/admin.html.erb',
  'app/views/panel/dashboard/index.html.erb',
  'app/views/panel/courses/index.html.erb',
  'app/views/panel/courses/new.html.erb',
  'app/views/panel/courses/edit.html.erb',
  'app/views/panel/courses/show.html.erb',
  'app/views/panel/members/index.html.erb',
  'app/views/panel/members/show.html.erb',
  'app/views/panel/members/edit.html.erb',
  'app/views/admin/dashboard/index.html.erb',
  'app/views/admin/users/index.html.erb',
  'app/views/admin/users/show.html.erb',
  'app/views/admin/users/new.html.erb',
  'app/views/admin/users/edit.html.erb',
  'app/views/kaminari/_page.html.erb'
]

replacements = {
  '#00b4d8' => '#00d4ff',
  '#0077b6' => '#0066ff',
  'rgba(0, 180, 216' => 'rgba(0, 212, 255',
  'rgba(0,180,216' => 'rgba(0,212,255'
}

files_to_update.each do |file_path|
  next unless File.exist?(file_path)
  
  content = File.read(file_path)
  original_content = content.dup
  
  replacements.each do |old_color, new_color|
    content.gsub!(old_color, new_color)
  end
  
  if content != original_content
    File.write(file_path, content)
    puts "✓ Atualizado: #{file_path}"
  else
    puts "- Sem mudanças: #{file_path}"
  end
end

puts "\n✅ Atualização de cores concluída!"
