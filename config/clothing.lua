RestrictedClothing = {
    male = {
        components = {
            -- Example: restrict a body armor/vest drawable.
            {
                component = 9,
                drawable = 15,
                texture = -1, -- -1 allows any texture for this drawable.
                permissions = { 'kruiger.clothing.leo' },
                message = 'You are not authorized to use this vest.'
            }
        },

        props = {
            -- Example: restrict a hat.
            {
                prop = 0,
                drawable = 46,
                texture = -1,
                permissions = { 'kruiger.clothing.leo' },
                message = 'You are not authorized to use this hat.'
            }
        }
    },

    female = {
        components = {
            -- Add mp_f_freemode_01 component restrictions here.
        },

        props = {
            -- Add mp_f_freemode_01 prop restrictions here.
        }
    }
}
