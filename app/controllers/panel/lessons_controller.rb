module Panel
  class LessonsController < BaseController
    before_action :set_course
    before_action :set_lesson, only: [:edit, :update, :destroy]

    def new
      @lesson = @course.lessons.build
    end

    def create
      @lesson = @course.lessons.build(lesson_params)
      
      if @lesson.save
        # Atualizar total de aulas do curso
        @course.update(total_lessons: @course.lessons.count)
        redirect_to panel_course_path(@course), notice: 'Aula criada com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @lesson.update(lesson_params)
        redirect_to panel_course_path(@course), notice: 'Aula atualizada com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @lesson.destroy
      # Atualizar total de aulas do curso
      @course.update(total_lessons: @course.lessons.count)
      redirect_to panel_course_path(@course), notice: 'Aula deletada com sucesso!'
    end

    private

    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_lesson
      @lesson = @course.lessons.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(:title, :description, :video_url, :duration_minutes, :order_number)
    end
  end
end
