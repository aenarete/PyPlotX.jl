module ControlPlots

import PyPlot as plt
import PyPlot.show as plshow
import Base.display
import JLD2

export plot, plotn, plotx, plotxy, plt, load, save

mutable struct PlotX
    X
    Y
    labels
    xlabel
    ylabels
    fig
    type::Int64
end

function save(filename::String, p::PlotX)
    JLD2.save(filename, "plot", p)
end

function load(filename::String)
    JLD2.load(filename)["plot"]
end

function plotn(X, Ys; xlabel="", ylabel="",
              labels=nothing, fig="", disp=false)
    if disp
        if fig != ""
            plt.figure(fig)
        end
        for (i, Y) in pairs(Ys)
            if isnothing(labels)
                plt.plot(X, Y)
            else
                if isnothing(labels[i]) || labels[i]==""
                    plt.plot(X, Y)
                else
                    plt.plot(X, Y; label=labels[i])
                end
            end
        end
        if xlabel != ""
            plt.xlabel(xlabel, fontsize=14); 
        end
        if ylabel != ""
            plt.ylabel(ylabel, fontsize=14); 
        end
        plt.grid(true)
        plt.legend()
        plt.tight_layout()
    else
        println("OK")
    end
    PlotX(X, Ys, labels, xlabel, ylabel, fig, 4)
end

function plot(X, Y; xlabel="", ylabel="", fig="", disp=false)
    if disp
        if fig != ""
            plt.figure(fig)
        end
        plt.plot(X, Y; label=ylabel)
        if xlabel != ""
            plt.xlabel(xlabel, fontsize=14); 
        end
        plt.ylabel(ylabel, fontsize=14); 
        plt.grid(true)
        plt.tight_layout()
    end
    PlotX(X, Y, nothing, xlabel, ylabel, fig, 1)
end

function plotx(X, Y...; xlabel="time [s]", ylabels=nothing, fig="", title="", disp=false)
    if disp
        len=length(Y)
        fig_ = plt.figure(fig, figsize=(8, len*2))
        i=1
        ax=[]
        for y in Y
            subplot=100len+10+i
            if i==1
                push!(ax, plt.subplot(subplot))
            else
                push!(ax, plt.subplot(subplot, sharex=ax[1]))
            end
            if i==1
                plt.suptitle(title, fontsize=14) # Super title
            end
            if ! isnothing(ylabels)
                lbl=ylabels[i]
            else
                lbl=""
            end
            plt.plot(X, y, label=lbl)
            plt.xlim(0, X[end])
            plt.ylabel(lbl, fontsize=14);  
            plt.grid(true)
            if i < len
                plt.setp(ax[i].get_xticklabels(), visible=false)
            end
            i+=1
        end
        plt.xlabel(xlabel, fontsize=14)
        
        plt.tight_layout()
    end
    PlotX(collect(X), Y, nothing, xlabel, ylabels, fig, 2)
end

function plotxy(X, Y; xlabel="", ylabel="", fig="", disp=false)
    if disp
        if fig != ""
            plt.figure(fig, figsize=(6,6))
        end
        plt.plot(X, Y)
        plt.xlabel(xlabel, fontsize=14);
        plt.ylabel(ylabel, fontsize=14);  
        plt.grid(true)
        plt.tight_layout()
    end
    PlotX(X, Y, xlabel, nothing, ylabel, fig, 3)
end

function display(P::PlotX)
    if P.type == 1
        plot(P.X, P.Y; xlabel=P.xlabel, ylabel=P.ylabels, fig=P.fig, disp=true)
    elseif P.type == 2
        plotx(P.X, P.Y...; xlabel=P.xlabel, ylabels=P.ylabels, fig=P.fig, disp=true)
    elseif P.type == 3
        plotxy(P.X, P.Y; xlabel=P.xlabel, ylabel=P.ylabels, fig=P.fig, disp=true)
    else
        plotn(P.X, P.Y; xlabel=P.xlabel, labels=P.labels, fig=P.fig, disp=true)
    end
    plt.pause(0.01)
    plt.show(block=false)
    nothing
end

end
