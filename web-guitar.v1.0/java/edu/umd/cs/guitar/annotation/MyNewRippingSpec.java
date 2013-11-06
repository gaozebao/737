package edu.umd.cs.guitar.annotation;

import edu.umd.cs.guitar.crawljax.ripper.RippingSpecification;

public class MyNewRippingSpec {

	@RippingSpec
	public RippingSpecification getRippingSpecification() {
		return new RippingSpecification();
	}
}
