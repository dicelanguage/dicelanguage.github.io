# Packages. Note: make sure that all the packages that you use here are
# (1) available in either your global environment or your current page environment
# (2) are installed in the `.github/workflows/deploy.yml` file. See both the
# Project.toml and the `deploy.yml` file here as examples.
#
using DelimitedFiles

# ========================================================================

###########
### 001 ###
###########

# approach 1; uses DelimitedFiles
function hfun_members_table(params::Vector{String})::String
    path_to_csv = params[1]
    members = readdlm(path_to_csv, ',', skipstart=1)
    # write a simple table
    io = IOBuffer()
    write(io, "<table>")
    write(io, "<tr><th>Name</th><th>GitHub alias</th></tr>")
    for (name, alias) in eachrow(members)
        write(io, "<tr>")
        write(io, "<td>$name</td>")
        write(io, """<td><a href="https://github.com/$alias">$alias</a></td>""")
        write(io, "</tr>")
    end
    write(io, "</table>")
    return String(take!(io))
end

###########
### 007 ###
###########

# case 1
hfun_case_1() =
    """<p style="color:red;">var read from foo is $(pagevar("foo", "var"))</p>"""

# case 2, note the `@delay`
@delay function hfun_case_2()
    all_tags = globvar("fd_page_tags")
    isnothing(all_tags) && return ""
    all_tags = union(values(all_tags)...)
    tagstr = strip(prod("$t " for t in all_tags))
    return """<p style="color:red;">tags: { $tagstr }</p>"""
end

###########
### 008 ###
###########

function lx_capa(com, _)
    # this first line extracts the content of the brace
    content = Franklin.content(com.braces[1])
    output = replace(content, "a" => "A")
    return "**$output**"
end

function env_cap(com, _)
    option = Franklin.content(com.braces[1])
    content = Franklin.content(com)
    output = replace(content, option => uppercase(option))
    return "~~~<b>~~~$output~~~</b>~~~"
end
