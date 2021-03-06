module TestElkan

using ParallelKMeans
using Test
using Random

@testset "basic kmeans elkan" begin
    X = [1. 2. 4.;]
    res = kmeans(Elkan(), X, 1; n_threads = 1, tol = 1e-6, verbose = false)
    @test res.assignments == [1, 1, 1]
    @test res.centers[1] ≈ 2.3333333333333335
    @test res.totalcost ≈ 4.666666666666666
    @test res.converged

    res = kmeans(Elkan(), X, 2; n_threads = 1, init = [1.0 4.0], tol = 1e-6, verbose = false)
    @test res.assignments == [1, 1, 2]
    @test res.centers ≈ [1.5 4.0]
    @test res.totalcost ≈ 0.5
    @test res.converged
end

@testset "elkan no convergence yield last result" begin
    X = [1. 2. 4.;]
    res = kmeans(Elkan(), X, 2; n_threads = 1, init = [1.0 4.0], tol = 1e-6, max_iters = 1, verbose = false)
    @test !res.converged
    @test res.totalcost ≈ 0.5
end

@testset "elkan singlethread linear separation" begin
    Random.seed!(2020)

    X = rand(3, 100)
    res = kmeans(Elkan(), X, 3; n_threads = 1, tol = 1e-10, max_iters = 10, verbose = false)

    @test res.totalcost ≈ 14.16198704459199
    @test !res.converged
    @test res.iterations == 10
end

@testset "elkan multithread linear separation quasi two threads" begin
    Random.seed!(2020)

    X = rand(3, 100)
    res = kmeans(Elkan(), X, 3; n_threads = 2, tol = 1e-6, verbose = false)

    @test res.totalcost ≈ 14.16198704459199
    @test res.converged
end

end # module
