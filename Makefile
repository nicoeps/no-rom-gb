rwildcard       =   $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
ASM             :=  rgbasm
LINKER          :=  rgblink
FIX             :=  rgbfix
BUILD_DIR       :=  build
PROJECT_NAME    ?=  no-rom
OUTPUT          :=  $(BUILD_DIR)/$(PROJECT_NAME)
SRC_DIR         :=  src
INC_DIR         :=  include/
DAT_DIR         :=  data/
SRC_Z80         :=  $(call rwildcard, $(SRC_DIR)/, *.s)
OBJ_FILES       :=  $(addprefix $(BUILD_DIR)/obj/, $(SRC_Z80:src/%.s=%.o))
OBJ_DIRS        :=  $(addprefix $(BUILD_DIR)/obj/, $(dir $(SRC_Z80:src/%.s=%.o)))
ASM_FLAGS       :=  -i $(INC_DIR) -i $(DAT_DIR)

.PHONY: all clean

all: fix

fix: build
	$(FIX) -p0 -v $(OUTPUT).gb

build: $(OBJ_FILES)
	$(LINKER) -m $(OUTPUT).map -n $(OUTPUT).sym -o $(OUTPUT).gb $(OBJ_FILES)
    
$(BUILD_DIR)/obj/%.o : src/%.s | $(OBJ_DIRS)
	$(ASM) $(ASM_FLAGS) -o $@ $<

$(OBJ_DIRS): 
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)

print-%  : ; @echo $* = $($*)
