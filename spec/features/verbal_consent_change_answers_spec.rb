# frozen_string_literal: true

describe "Verbal consent" do
  scenario "Change answers" do
    given_a_patient_is_in_an_hpv_programme

    when_i_get_consent_for_the_patient
    and_i_choose_the_parent
    and_i_fill_out_the_consent_details(parent_name: @parent.full_name)
    then_i_see_the_confirmation_page

    when_i_click_on_change_name
    and_i_fill_out_the_consent_details(parent_name: "New parent name")
    then_i_see_the_confirmation_page
  end

  def given_a_patient_is_in_an_hpv_programme
    programmes = [create(:programme, :hpv)]
    organisation = create(:organisation, programmes:)

    @nurse = create(:nurse, organisation:)

    @session = create(:session, organisation:, programmes:)

    @parent = create(:parent)
    @patient = create(:patient, session: @session, parents: [@parent])
  end

  def when_i_get_consent_for_the_patient
    sign_in @nurse
    visit session_consent_path(@session)
    click_link @patient.full_name
    click_button "Get consent"
  end

  def and_i_choose_the_parent
    click_button "Continue"
    expect(page).to have_content(
      "Choose who you are trying to get consent from"
    )

    choose "#{@parent.full_name} (#{@patient.parent_relationships.first.label})"
    click_button "Continue"
  end

  def and_i_fill_out_the_consent_details(parent_name:)
    expect(page).to have_content(
      "Details for #{parent_name} (#{@patient.parent_relationships.first.label})"
    )

    fill_in "Full name", with: "New parent name"
    click_button "Continue"

    choose "By phone"
    click_button "Continue"

    choose "Yes, they agree"
    click_button "Continue"

    find_all(".nhsuk-fieldset")[0].choose "No"
    find_all(".nhsuk-fieldset")[1].choose "No"
    find_all(".nhsuk-fieldset")[2].choose "No"
    find_all(".nhsuk-fieldset")[3].choose "No"
    click_button "Continue"

    choose "Yes, it’s safe to vaccinate"
    click_button "Continue"
  end

  def then_i_see_the_confirmation_page
    expect(page).to have_content("Check and confirm answers")
  end

  def when_i_click_on_change_name
    click_link "Change name"
  end
end
