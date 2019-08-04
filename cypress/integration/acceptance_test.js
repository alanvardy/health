describe('Acceptance Test', function () {
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
  it('Registers an account', function () {
    cy.contains('Register').click()
    cy.get('input#user_email').type('test@test.com')
    cy.get('input#user_name').type('Dufus McDumbface')
    cy.get('input#user_password').type('securepassword')
    cy.get('input#user_confirm_password').type('securepassword')
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
})