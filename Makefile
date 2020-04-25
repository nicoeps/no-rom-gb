LINKER    := rgblink
ASM       := rgbasm
FIX       := rgbfix

INCDIR    := include/
DATDIR    := data/
ASMFLAGS  := -i $(INCDIR) -i $(DATDIR)

SRCDIR    := src
OBJDIR    := build
SRCS      := $(wildcard $(SRCDIR)/*.s)
OBJS      := $(SRCS:$(SRCDIR)/%.s=$(OBJDIR)/%.o)
ROMS      := $(SRCS:$(SRCDIR)/%.s=$(OBJDIR)/%.gb)

all: $(OBJDIR) $(ROMS)

$(OBJDIR):
	mkdir -p $@

$(ROMS): $(OBJDIR)/%.gb : $(OBJDIR)/%.o
	$(LINKER) -n $(basename $@).sym -m $(basename $@).map -o $@ $<
	$(FIX) -v -p0 $@

$(OBJS): $(OBJDIR)/%.o : $(SRCDIR)/%.s
	$(ASM) $(ASMFLAGS) -o $@ $<

.PHONY: clean

clean:
	rm -rf $(OBJDIR)
