SHELL := /usr/bin/env bash

NAME = extLib

HEADERS = $(wildcard *.h)
SOURCES = $(wildcard *.cpp)

DEPDIR = .deps
BUILDDIR = .build

LIB := lib$(shell NAME=$(NAME); echo $${NAME^}).a

CXXFLAGS = -std=c++17 -I.. -Wall -Werror -Wextra -pthread -Wno-unused-parameter

OBJS = $(SOURCES:%.cpp=$(BUILDDIR)/%.o)

$(BUILDDIR)/%.o: %.cpp $(HEADERS)
	$(CXX) -Wp,-MD,$(DEPDIR)/$(@F).d -c $(CXXFLAGS) -o $@ $<
	@echo -n "$@: " > $(DEPDIR)/$(@F).P;	sed -e 's/#.*//' -e 's/^[^:]*: *//' < $(DEPDIR)/$(@F).d >> $(DEPDIR)/$(@F).P; sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' -e '/^$$/ d' -e 's/$$/ :/' < $(DEPDIR)/$(@F).d >> $(DEPDIR)/$(@F).P; rm -f $(DEPDIR)/$(@F).d
 
-include $(DEPDIR)/*.P

$(OBJS): | $(DEPDIR) $(BUILDDIR)

$(SOURCES): $(LIBS_CONFIGURE) | $(BUILD_DIR)

$(LIB): $(OBJS)
	ar cruv $@ $(OBJS)
	ranlib $@

$(DEPDIR) $(BUILDDIR):
	@mkdir -p $@


clean:
	rm -rf $(BUILDDIR) $(LIB) $(DEPDIR)


all: $(LIB)

.PHONY: all
.DEFAULT_GOAL := all
