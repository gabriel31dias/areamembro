module Panel
  class QuizzesController < BaseController
    before_action :set_course_and_lesson
    before_action :set_quiz, only: [:edit, :update, :destroy]

    def new
      @quiz = @lesson.build_quiz(title: "Teste: #{@lesson.title}", passing_score: 70)
    end

    def create
      @quiz = @lesson.build_quiz(quiz_params)

      if @quiz.save
        redirect_to panel_course_path(@course), notice: 'Teste criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @quiz.update(quiz_params)
        redirect_to panel_course_path(@course), notice: 'Teste atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @quiz.destroy
      redirect_to panel_course_path(@course), notice: 'Teste removido.'
    end

    private

    def set_course_and_lesson
      @course = current_panel_user.courses.find(params[:course_id])
      @lesson = @course.lessons.find(params[:lesson_id])
    end

    def set_quiz
      @quiz = @lesson.quiz
      redirect_to new_panel_course_lesson_quiz_path(@course, @lesson) if @quiz.nil?
    end

    def quiz_params
      params.require(:quiz).permit(
        :title, :passing_score,
        questions_attributes: [
          :id, :statement, :order_number, :correct_index, :_destroy,
          question_options_attributes: [:id, :text, :_destroy]
        ]
      )
    end
  end
end
