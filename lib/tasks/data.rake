# frozen_string_literal: true

namespace :swapsea do
  namespace :data do
    desc 'Daily transfer from staging tables to working tables.'
    task transfer: :environment do |_task|
      if StagingAward.transfer
        EventLog.create!(subject: 'Transfer', desc: 'Awards import success.')
      else
        EventLog.create!(subject: 'Transfer', desc: 'Awards import failed.')
      end

      if StagingUser.transfer
        EventLog.create!(subject: 'Transfer', desc: 'Users import success.')
      else
        EventLog.create!(subject: 'Transfer', desc: 'Users import failed.')
      end

      if StagingPatrolMember.transfer
        EventLog.create!(subject: 'Transfer', desc: 'Patrol Member import success.')
      else
        EventLog.create!(subject: 'Transfer', desc: 'Patrol Member import failed.')
      end

      num_juniors = User.juniors.length
      if NumJuniors.positive?
        EventLog.create!(subject: 'Transfer', desc: "Removing #{num_juniors} junior members...")
        User.where(id: User.juniors.select(:id)).delete_all
        num_juniors = User.juniors.length
        EventLog.create!(subject: 'Transfer', desc: "There are #{num_juniors} junior members remaining.")
      else
        EventLog.create!(subject: 'Transfer', desc: 'No junior members found to remove.')
      end
    end
  end
end
