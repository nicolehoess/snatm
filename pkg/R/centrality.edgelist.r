## This file is part of snatm. snatm is free software: you can redistribute it
## and/or modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation, either version 2 of the License,
## or (at your option) any later version.
##
## snatm is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
##
## Copyright 2011 by Angela Bohn <angela.bohn@gmail.com>
## Copyright 2013 by Siemens AG, Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
## All Rights Reserved.

library("sna")
centrality.edgelist <- 
function (terms, apply.to, data.path, max.terms=20)
{
    if (!(apply.to %in% c("subject", "content")))
      stop("apply.to must be either 'subject' or 'content'")
    edgelist <- c()
    keywords <- new.env()
    sizes <- rep(0, length(terms))

    for (i in seq_along(terms)) {
      tmp <- unlist(strsplit(file.path(data.path, "commnet.terms", apply.to,
                                       paste("net_", terms[i], ".rda", sep = "")),
                             split = "/"))
      tmp <- tmp[length(tmp)]
      filelist <- list.files(file.path(data.path, "commnet.terms", apply.to))

      if (is.element(tmp, filelist)) {
        load(file.path(data.path, "commnet.terms", apply.to,
                       paste("net_", terms[i], ".rda", sep = "")))

        net <- sna::component.largest(net, result = "graph",
                                      connected = "weak")
        if (!is.null(dim(net))) {
          sizes[i] <- dim(net)[1]
        }

        rm(net)
      }
    }

    if (max.terms > length(sizes))
      max.terms <- length(sizes)

    for (i in order(sizes, decreasing=T)[1:max.terms]) {
      if (sizes[i] == 0)
        next

      load(file.path(data.path, "commnet.terms", apply.to,
                     paste("net_", terms[i], ".rda", sep = "")))
      net <- sna::component.largest(net, result = "graph",
                                    connected = "weak")
      authors <- rownames(net)
      value <- sna::degree(net, cmode = "outdegree")
      value <- cbind(authors, value)
      value <- ordermatrix(value, 2)

      ## If there is only a single row in the result matrix, R
      ## chooses character vector as data type, which requires
      ## other selection operators than use below. Make sure that
      ## he same subsetting can be used in every case.
      if ("character" %in% class(value)) {
          value <- matrix(value, nrow=1)
      }

      value <- cbind(value[, 1], seq(1:dim(value)[1])/dim(value)[1])
      edgelist <- rbind(edgelist, cbind(value[, 1], terms[i], value[, 2]))
    }

    ## Provide textual indices
    ## edgelist[,1] = author
    ## edgelist[,2] = term
    ## edgelist[,3] = outdegree
    if (!is.null(edgelist)) {
        dimnames(edgelist) <- list(NULL, c("author", "term", "outdegree"))
    }
    return (list(edgelist=edgelist, sizes=sizes))
}
