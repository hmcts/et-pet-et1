package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import com.typesafe.config._



class EmploymentTribunalsPerformance extends Simulation
with HttpConfiguration
{
  val conf = ConfigFactory.load()
  val baseurl = conf.getString("baseUrl")
  val httpconf = httpProtocol.baseURL(baseurl).disableCaching

  val scenario1 = scenario("Happy Path for Employment Tribunal Refunds")

    .exec(http("Start Session")
        .get("/apply/refund/new"))

    //////  Page 1 of 7 - Introduction Page //////

    .exec(http("Page 1 of 7 - Introduction Page")
        .put("/apply/refund/profile-selection")
        .formParam("refunds_profile_selection[profile_type]", "claimant_direct_not_reimbursed")
        .check(status.is(200)))

    //////  Page 2 of 7 - Claimant details //////

    .exec(http("Page 2 of 7 - Claimant details")
        .put("/apply/refund/applicant")
        .formParam("refunds_applicant[has_name_changed]", "false")
        .formParam("refunds_applicant[applicant_title]", "ms")
        .formParam("refunds_applicant[applicant_first_name]", "Sophie")
        .formParam("refunds_applicant[applicant_last_name]", "Smith")
        .formParam("refunds_applicant[applicant_date_of_birth][day]", "07")
        .formParam("refunds_applicant[applicant_date_of_birth][month]", "01")
        .formParam("refunds_applicant[applicant_date_of_birth][year]", "1983")
        .formParam("refunds_applicant[applicant_address_building]", "102")
        .formParam("refunds_applicant[applicant_address_street]", "Petty France")
        .formParam("refunds_applicant[applicant_address_locality]", "London")
        .formParam("refunds_applicant[applicant_address_post_code]", "SW1H 9AJ")
        .formParam("refunds_applicant[applicant_address_telephone_number]", "02074903123")
        .check(status.is(200)))

  val userCount = conf.getInt("users")
  val durationInSeconds  = conf.getLong("duration")

  setUp(
    scenario1.inject(rampUsers(userCount) over (durationInSeconds seconds)).protocols(httpconf)
  )

}
