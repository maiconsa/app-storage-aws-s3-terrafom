package com.storage.aws.app.usecases;

import java.util.function.Function;

public interface UsecaseService<T,R> extends Function<T, R> {
	
}
