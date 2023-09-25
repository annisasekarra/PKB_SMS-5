using CSV, DataFrames, Plots, GLM

csv_file_path = "iris.csv"
iris_data = CSV.File(csv_file_path) |> DataFrame

iris_data = filter(row -> row.class in ["Iris-setosa", "Iris-virginica"], iris_data)

scatter(iris_data[!, "petallength"][iris_data[!, "class"] .== "Iris-setosa"], iris_data[!, "petalwidth"][iris_data[!, "class"] .== "Iris-setosa"], color="blue", label="Iris-setosa", shape=:dtriangle)
scatter!(iris_data[!, "petallength"][iris_data[!, "class"] .== "Iris-virginica"], iris_data[!, "petalwidth"][iris_data[!, "class"] .== "Iris-virginica"], color="yellow", label="Iris-virginica", shape=:diamond)

title!("Grafik Batas Kelas (Setosa dan Virginica)")
xlabel!("Petal Length")
ylabel!("Petal Width")

iris_data[!, "species_binary"] .= iris_data[!, "class"] .== "Iris-setosa"

model = glm(@formula(species_binary ~ petallength + petalwidth), iris_data, Binomial())

x_boundary = range(minimum(iris_data.petallength), maximum(iris_data.petallength), length=100)
y_boundary = (-coef(model)[1] .- coef(model)[2] .* x_boundary) ./ coef(model)[3]

plot!(x_boundary, y_boundary, color="red", label="Class Boundary")