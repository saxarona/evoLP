abstract type CrossoverMethod end

struct SinglePointCrossover <: CrossoverMethod end

struct TwoPointCrossover <: CrossoverMethod end

struct UniformCrossover <: CrossoverMethod end

struct InterpolationCrossover <: CrossoverMethod
    λ
end

"""
Crossover methods operate on two parents `a` and `b` to generate
a new candidate solution. Some of the `CrossoverMethod`s have
parameters to control how the reproduction is performed. All
operators return a new individual. No individual is modified.
"""

"""
    cross(::SinglePointCrossover, a, b)

Single point crossover between parents `a` and `b`, at a
random point in the chromosome.
"""
function cross(::SinglePointCrossover, a, b)
	i = rand(1:length(a))
	return vcat(a[1:i], b[i+1:end])
end

"""
    cross(::TwoPointCrossover, a, b)

Two point crossover between parents `a` and `b`, at two
random points in the chromosome.
"""
function cross(::TwoPointCrossover, a, b)
	n = length(a)
	i, j = rand(1:n, 2)
	if i > j
		(i, j) = (j, i)
	end
	return vcat(a[1:i], b[i+1:j], a[j+1:n])
end

"""
    crossover(::UniformCrossover, a, b)

Uniform crossover between parents `a` and `b`. Each gene
of the chromosome is randomly selected from one of the parents.
"""
function cross(::UniformCrossover, a, b)
	child = copy(a)
	for i in 1:length(a)
		if rand() < 0.5
			child[i] = b[i]
		end
	end
	return child
end

"""
Linear Interpolation crossover between parents `a` and `b`.
The resulting individual is the addition of a scaled version of
each of the parents, using `λ` as a control parameter.
"""
cross(C::InterpolationCrossover, a, b) = (1 - C.λ)*a + C.λ*b
