namespace :update_ideas do
  desc "Update status ideas when its end time is passed."
  task status: :environment do
    ideas = Idea.where(status: [Idea::COMUNIDEIA_EM_ACAO, Idea::COMUNIDEIA_EM_FINANCIAMENTO])
    finished_ideas = ideas.where("date_end < ?", DateTime.now)
    finished_ideas.update_all(status: Idea::PROJECT_FINANCED)
  end
end