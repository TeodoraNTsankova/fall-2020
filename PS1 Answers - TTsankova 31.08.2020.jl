#=

Pkg.add("JLD2")
Pkg.add("Random")
Pkg.add("LinearAlgebra")
Pkg.add("Statistics")
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("FreqTables")

Pkg.add("Kronecker")

=#


import JLD2
import Random
import LinearAlgebra
import Statistics
import CSV
import DataFrames
import FreqTables

import Kronecker

###################################################################
### Question 1

#function q1()

## (a)

Random.seed!(1234)

# i matrix 10* 7 with uniform values between -5 and 10

A=rand(-5:10,(10,7)) # -5:10 is the range, 10,7 is the size of the matrix

# ii matrix 10*7 with normal values (-2,15) => not re-centered, do not know how

B=randn(10,7)*15 # 15 is the standard deviation

# iii put 5 rows * 5 columns of the first together with 5 rows * 2 columns (last) of the second

A_small=A[1:5,:1:5]
A_small
B_small=B[1:5,6:7]
B_small

C=[A_small B_small] # same on the row dimension only 5*5 and 5*2 matrix

size(C)

# iv 10*7 matrix where values are equal to As if positive, else 0s

A

D=A

A # it seems that this changes M1 too - Why?

for row=1:10
    for column=1:7  # goes through all arguments of the matrix
        if D[row,column]<0
            D[row,column]=0
        end
    end
end

D

## (b) get the number of elements of A

length(A)

## (c) list the number of unique elements in D

nr_unique=length(unique(D))

# (d)

println(reshape(B,(70,1))) # reshaped it into a vector 70*1

size(reshape(B,(70,1))) # 70,1

size(reshape(B,(1,70))) # 1,70

# (e)

E=rand(2,10,7) # a matrix with the right dimensions but random numbers

E[1,1:10,1:7]=A

E[2,1:10,1:7]=B

E

# (f)

E=permutedims(E, [2,3,1]) # what used to be the second dimension now is first ...

E

# (g)

F = A ⊗ B

#F = C ⊗ E # no method matching error - Why?

size(A) # 10,7
size(B) # 10,7
size(C) # 5,7
size(E) # 10,7,2 => dimensions do not match

# (h)

using JLD2
@save("C:/Users/tsankova/Dropbox/Structural Course Material/Week 1/matrixpractice.jld", "arr", A, B, C, D, E, F)

# (i)

using JLD2
@save("C:/Users/tsankova/Dropbox/Structural Course Material/Week 1/firstmatrix.jld", "arr", A, B, C, D)

# (j)

using JLD2
@save("C:/Users/tsankova/Dropbox/Structural Course Material/Week 1/Cmatrix.csv", "arr", C)

# (k)

using DataFrames
D=convert(DataFrame, D)

using JLD2
@save("C:/Users/tsankova/Dropbox/Structural Course Material/Week 1/Dmatrix.dat", D)

# (l)

#end

#q1()

###################################################################
### Question 2

#function q2()

# (a)

AB=zeros(10,7)

for row=1:10
    for column=1:7  # goes through all arguments of the matrix
        a=A[row,column]
        println(a)
        b=B[row,column]
        println(b)
        c=a*b
        println(c)
        AB[row,column]=c
    end
end

# (b)

C

Cprime=reshape(C,(35,1))

Cprime=Vector{Float64}(vec(Cprime))

Cprime

try
    for row=1:length(Cprime) # length changes as drop obs. so in the end there is an error message
        if Cprime[row]>5
            deleteat!(Cprime,row)
        elseif Cprime[row]<-5
            deleteat!(Cprime,row)
        end
    end
catch
finally
end

Cprime # 26 elements left

# Do it not in a loop => left for later

# (c)

# (d)

# (e)

# (f)

#end

#q2()

###################################################################
### Question 3

#function q3()

# (a)

using CSV
nlsw88 = CSV.read("nlsw88.csv")

names(nlsw88) # lists variable names, seem file

using Statistics
mean(nlsw88.grade) # mean of grade variable - missing?

# missing values?

using JLD2
@save("C:/Users/tsankova/Dropbox/Structural Course Material/Week 1/nlsw88.jld", "df", nlsw88)

# (b)

# share married - married variable

using Statistics
mean(nlsw88.married) # 0.642

# share with a college degree - collgrad variable

using Statistics
mean(nlsw88.collgrad) # 0.237

# (c) do not know how to show percentag ???

using FreqTables
freqtable(nlsw88.race)

# (d)

summarystats=describe(nlsw88) # min, max, median, mean values

nlsw88

using FreqTables
freqtable(nlsw88.grade) # 2 missing

# (e)

using FreqTables
freqtable(nlsw88.industry)
freqtable(nlsw88.occupation)
freqtable(nlsw88.industry,nlsw88.occupation)

# (f)

ind_wage=select(nlsw88,:industry,:wage) # select data wanted
ind_wage_grouped=groupby(ind_wage,1) # create a grouped data frame
ind_wage_selected=combine(ind_wage_grouped,:wage => mean) # calculate mean wage by group

occ_wage=select(nlsw88,:occupation,:wage)
occ_wage_grouped=groupby(occ_wage,1)
occ_wage_selected=combine(occ_wage_grouped,:wage => mean)

#end

#q3()

###################################################################
### Question 4

#function q4()

# (a)

@load "firstmatrix.jld"

# (b) and (c)

function matrixops(A_some,B_some)

    #=

    The function takes A and B matrices as agruments of the same
    dimension, then creates three matrices - one element-by-element
    multiplication, one matrix multiplication and one matrix
    summation

    =#

    size_A=size(A_some)

    size_A_r=size_A[1] # number of rows
    size_A_c=size_A[2] # number of columns

    e_by_e_product_A_B=zeros(size_A_r,size_A_c)

    for row in 1:size_A_r
        for column in 1:size_A_c
            a=A_some[row,column]
            b=B_some[row,column]
            c=a*b
            e_by_e_product_A_B[row,column]=c
        end
    end

    A_transpose_B=transpose(A_some)*B_some

    A_plus_B=A_some+B_some

    return e_by_e_product_A_B, A_transpose_B, A_plus_B

end

# (d)

matrixops(A,B) # returns three matrices of the correct size

# (e)

function matrixops(A_some,B_some)

    size_A=size(A_some)
    size_B=size(B_some)

    if size_A==size_B # like stata

        size_A_r=size_A[1] # number of rows
        size_A_c=size_A[2] # number of columns

        e_by_e_product_A_B=zeros(size_A_r,size_A_c)

        for row in 1:size_A_r
            for column in 1:size_A_c
                a=A_some[row,column]
                b=B_some[row,column]
                c=a*b
                e_by_e_product_A_B[row,column]=c
            end
        end

        A_transpose_B=transpose(A_some)*B_some

        A_plus_B=A_some+B_some

        return e_by_e_product_A_B, A_transpose_B, A_plus_B

    else

        println("Matrices of different sizes")

    end

end

# (e)

matrixops(C,D) # prints the message

# (f)

ttl_exp=convert(Array,nlsw88.ttl_exp)

wage=convert(Array,nlsw88.wage)

ttl_exp
wage # vectors

ttl_exp_array=reshape(ttl_exp, length(ttl_exp), 1)
wage_array=reshape(wage, length(wage), 1)

matrixops(ttl_exp_array,wage_array) # yes

#end

#q4()

#=

List of issues:

Do not know how to fix the normal distribution
to have a different mean and standard deviation

Have not done the second part of Question 2 -
need to see answers

Q: Do we write using ...
when the packages have sub-packaged / commands with the same name
only or we should always do it? Seems wordy

Q: Why do we need three dimensional arrays?

Q: If I want to replace the values of a matrix with something
one by one then I first need to create an empty / zeros matrix -
is this true?

Do not know how to declare the functions
without inputs and outpits
- using expressions need to come forward
- some other pieces of code do not run (kron product)
- unclear when to use return as well

Q: Is it good practice to wrap everything in a function?

Q: Should I have se a home directory?
