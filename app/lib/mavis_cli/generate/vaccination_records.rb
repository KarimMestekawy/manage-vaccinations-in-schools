# frozen_string_literal: true

module MavisCLI
  module Generate
    class VaccinationRecords < Dry::CLI::Command
      desc "Generate vaccination records (and attendances if required)"
      option :organisation,
             aliases: ["-o"],
             default: "A9A5A",
             desc: "ODS code of organisation to generate consents for"
      option :programme_type,
             aliases: ["-p"],
             default: "hpv",
             desc:
               "Programme type to generate consents for (hpv, menacwy, td_ipv, etc)"
      option :session_id,
             aliases: ["-s"],
             desc:
               "Generate consents for patients in a session, instead of" \
                 " across the entire organisation"
      option :administered,
             default: 0,
             aliases: ["-A"],
             desc: "Number of administered vaccination records to create"

      def call(
        organisation:,
        programme_type:,
        administered:,
        session_id: nil,
        **
      )
        MavisCLI.load_rails

        session = Session.find(session_id) if session_id

        ::Generate::VaccinationRecords.call(
          organisation: Organisation.find_by(ods_code: organisation),
          programme:
            Programme.includes(:organisations).find_by(type: programme_type),
          session:,
          administered: administered.to_i
        )
      end
    end
  end

  register "generate", aliases: ["g"] do |prefix|
    prefix.register "vaccination-records", Generate::VaccinationRecords
  end
end
