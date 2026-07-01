class MoveQuizToLesson < ActiveRecord::Migration[8.1]
  def up
    # Remove quizzes antigos (eram por curso) para começar limpo no modelo por aula
    execute "DELETE FROM quizzes"

    add_reference :quizzes, :lesson, foreign_key: true, index: { unique: true }, type: :string
    remove_index :quizzes, :course_id if index_exists?(:quizzes, :course_id)
    change_column_null :quizzes, :course_id, true
  end

  def down
    remove_reference :quizzes, :lesson
    add_index :quizzes, :course_id, unique: true
    change_column_null :quizzes, :course_id, false
  end
end
