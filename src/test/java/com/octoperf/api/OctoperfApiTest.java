package com.octoperf.api;

import com.intuit.karate.junit5.Karate;

class OctoperfApiTest {

    @Karate.Test
    Karate testLoginApi() {
        return Karate.run("octoperf_login").relativeTo(getClass());
    }
}
