describe('Acceptance Test', function () {
  const password = 'securepassword'
  const name = 'Dufus McDumbface'
  const new_name = 'Smarty McSmartface'
  const email = 'testemail@test.com'

  beforeEach(function () {
    // before each test, we can automatically preserve the
    // 'session_id' and 'remember_token' cookies. this means they
    // will not be cleared before the NEXT test starts.
    //
    // the name of your cookies will likely be different
    // this is just a simple example
    Cypress.Cookies.debug(true)
    Cypress.Cookies.preserveOnce('_health_key')
  })

  it('Visits the main page', function () {
    cy.visit('http://localhost:5000')
  })

  it('Uses the contact form', function () {
    cy.contains('Contact').click()
    cy.get('input#message_name').type(name)
    cy.get('input#message_from_email').type(email)
    cy.get('textarea#message_message').type('What a great website Alan!')
    cy.get('[type=submit]').click()
    cy.contains('Your message has been sent!')
  })

  it('Registers an account', function () {
    cy.contains('Register').click()
    cy.get('input#user_email').type(email)
    cy.get('input#user_name').type(name)
    cy.get('input#user_password').type(password)
    cy.get('input#user_confirm_password').type(password)
    cy.get('[type=submit]').click()
    cy.contains('Welcome back Dufus McDumbface')
  })

  it('Enters a weight record', function () {
    cy.contains('Weight').click()
    cy.get('#trend').find('input#log_weight').type('234')
    cy.get('#trend').find('[type=submit]').click()
    cy.contains('Recent Logs').click()
    cy.contains('234.0')
  })

  it('Enters measurements', function () {
    cy.contains('Measurements').click()
    cy.contains('New').click()
    cy.get('input#measurement_left_bicep').type('234')
    cy.get('input#measurement_right_bicep').type('234')
    cy.get('input#measurement_left_thigh').type('234')
    cy.get('input#measurement_right_thigh').type('234')
    cy.get('input#measurement_chest').type('234')
    cy.get('input#measurement_waist').type('234')
    cy.get('input#measurement_buttocks').type('99')
    cy.get('[type=submit]').click()
    cy.contains('99.0')
  })

  it('Changes name', function () {
    cy.contains(name).click()
    cy.contains('Settings').click()
    cy.get('input#user_name').clear()
    cy.get('input#user_name').type(new_name)
    cy.get('input#user_current_password').type(password)
    cy.get('[type=submit]').click()
    cy.contains(new_name)
    cy.contains('Your account has been updated.')
  })

  it('Signs out', function () {
    cy.contains(new_name).click()
    cy.contains('Sign Out').click()
    cy.contains('Goodbye!')
  })

  it('Logs back in', function () {
    cy.get('input#user_email').type(email)
    cy.get('input#user_password').type(password)
    cy.get('[type=submit]').click()
    cy.contains('Welcome back')
  })
})