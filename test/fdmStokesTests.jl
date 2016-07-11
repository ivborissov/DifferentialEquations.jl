using DifferentialEquations, LaTeXStrings, Plots

## Change plot commands to GR

Δx = 1//2^3 #Super large for quick testing. Lower this for better results.
mesh = FDMMesh(Δx,mins=[-1;-1],maxs=[1;1])
prob = homogeneousStokesExample()

#DGS Convergence
@time sol = solve(prob,mesh,converrors=true,maxiters=200,alg="DGS")

err1 = sol.converrors["rul∞"]
err2 = sol.converrors["rvl∞"]
err3 = sol.converrors["rpl∞"]

plot([1:length(err1) 1:length(err2) 1:length(err3)],[err1 err2 err3],yscale=:log10,xguide="Error",yguide="Iterations",title=L"DGS Convergence, $\Delta t = 2^{-3}$",label=["u" "v" "p"])

#Multigrid Relative Convergence
@time sol = solve(prob,mesh,converrors=true,maxiters=20,alg="Multigrid",levels=4)


err1 = sol.converrors["rresul2"]
err2 = sol.converrors["rresvl2"]
err3 = sol.converrors["rrespl2"]
plot([1:length(err1) 1:length(err2) 1:length(err3)],[err1 err2 err3],yscale=:log10,xguide="Error",yguide="Iterations",title=L"Multigrid Relative Residual Convergence, $\Delta t = 2^{-3}$",label=["u" "v" "p"])

err1[end] < 1e-12
