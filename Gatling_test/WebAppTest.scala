
import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class WebAppTest extends Simulation {

	val httpProtocol = http
		.baseUrl("http://54.155.236.74")
		.inferHtmlResources()
		.acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9")
		.acceptEncodingHeader("gzip, deflate")
		.acceptLanguageHeader("en-GB,en-US;q=0.9,en;q=0.8")
		.userAgentHeader("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36")

	val headers_0 = Map(
		"If-None-Match" -> """W/"27f-zD1fXxkgTq7w0hukkjiUTu1am0w"""",
		"Proxy-Connection" -> "keep-alive",
		"Upgrade-Insecure-Requests" -> "1")

	val headers_1 = Map(
		"Accept" -> "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
		"If-Modified-Since" -> "Thu, 02 Sep 2021 10:43:17 GMT",
		"If-None-Match" -> """W/"4002-17ba61b14bf"""",
		"Proxy-Connection" -> "keep-alive")

	val headers_2 = Map(
		"If-None-Match" -> """W/"10ff7-f3PHTNjag4fwGn78PNVbyGfCpQU"""",
		"Proxy-Connection" -> "keep-alive",
		"Upgrade-Insecure-Requests" -> "1")

	val headers_3 = Map(
		"Accept" -> "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
		"If-Modified-Since" -> "Thu, 02 Sep 2021 10:43:17 GMT",
		"If-None-Match" -> """W/"bfb-17ba61b147b"""",
		"Proxy-Connection" -> "keep-alive")

	val headers_4 = Map(
		"Proxy-Connection" -> "keep-alive",
		"Upgrade-Insecure-Requests" -> "1")

	val headers_9 = Map(
		"If-None-Match" -> """W/"26a-HeAqeJDApCNKqY27//rfTMTdiE0"""",
		"Proxy-Connection" -> "keep-alive",
		"Upgrade-Insecure-Requests" -> "1")

	val headers_14 = Map(
		"If-None-Match" -> """W/"26c-QncKJ6YLRUoj//BVwg102jbW3uY"""",
		"Proxy-Connection" -> "keep-alive",
		"Upgrade-Insecure-Requests" -> "1")



	val scn = scenario("WebAppTest")
		.exec(http("request_0")
			.get("/")
			.headers(headers_0)
			.resources(http("request_1")
			.get("/images/squarelogo.jpg")
			.headers(headers_1)))
		.pause(4)
		.exec(http("request_2")
			.get("/posts")
			.headers(headers_2)
			.resources(http("request_3")
			.get("/images/logo.png")
			.headers(headers_3)))
		.pause(5)
		.exec(http("request_4")
			.get("/fibonacci/1")
			.headers(headers_4))
		.pause(1)
		.exec(http("request_5")
			.get("/fibonacci/2")
			.headers(headers_4))
		.pause(1)
		.exec(http("request_6")
			.get("/fibonacci/3")
			.headers(headers_4))
		.pause(2)
		.exec(http("request_7")
			.get("/fibonacci/4")
			.headers(headers_4))
		.pause(1)
		.exec(http("request_8")
			.get("/fibonacci/5")
			.headers(headers_4))
		.pause(1)
		.exec(http("request_9")
			.get("/fibonacci/6")
			.headers(headers_9)
			.resources(http("request_10")
			.get("/images/logo.png")
			.headers(headers_3)))
		.pause(2)
		.exec(http("request_11")
			.get("/fibonacci/7")
			.headers(headers_4))
		.pause(2)
		.exec(http("request_12")
			.get("/fibonacci/8")
			.headers(headers_4))
		.pause(2)
		.exec(http("request_13")
			.get("/fibonacci/9")
			.headers(headers_4))
		.pause(1)
		.exec(http("request_14")
			.get("/fibonacci/10")
			.headers(headers_14)
			.resources(http("request_15")
			.get("/images/logo.png")
			.headers(headers_3)))

	setUp(scn.inject(atOnceUsers(1000))).protocols(httpProtocol)
}