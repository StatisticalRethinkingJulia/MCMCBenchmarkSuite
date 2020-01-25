using MCMCBenchmarkSuite, Test, Random

@testset "SDT Tests " begin
    Random.seed!(6505)
    path = pathof(MCMCBenchmarkSuite)
    include(joinpath(path, "../SDT/SDT_Functions.jl"))
    include(joinpath(path, "../SDT/SDT.jl"))
    Nd = 10^4
    d = 2.0
    c = 0.0
    Nreps = 1
    ProjDir = @__DIR__
    cd(ProjDir)

    samplers=(CmdStanNUTS(CmdStanConfig, ProjDir),
        AHMCNUTS(AHMC_SDT, AHMCconfig),
        DHMCNUTS(sampleDHMC)
        )
    options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)
    @test_skip results = benchmark(samplers, simulateSDT, Nreps; options...)
    @test_skip results[!,:d_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ d atol = .05
    @test_skip results[!,:d_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ d atol = .05
    @test_skip results[!,:d_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ d atol = .05
    @test_skip results[!,:c_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ c atol = .05
    @test_skip results[!,:c_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ c atol = .05
    @test_skip results[!,:c_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ c atol = .05
    @test_skip results[!,:d_sampler_rhat][1] ≈ 1 atol = .03
    @test_skip results[!,:c_sampler_rhat][1] ≈ 1 atol = .03
    isdir("tmp") && rm("tmp", recursive=true)
    println("Skipping tests due to error in https://github.com/TuringLang/Turing.jl/issues/1055")
end
