/*
 * SPDX-License-Identifier: LGPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023-2024 Ryo Nakano <ryonakaknock3@gmail.com>
 */

/**
 * A {@link Ryokucha.DropDownText} is a simple variant of [[https://valadoc.org/gtk4/Gtk.DropDown.html|Gtk.DropDown]]
 * for text-only use cases.
 *
 * It is designed to have similar looks, feels, and interface with
 * [[https://valadoc.org/gtk4/Gtk.ComboBoxText.html|Gtk.ComboBoxText]], which is deprecated in GTK 4.10.<<BR>>
 * While it is said to use Gtk.DropDown with a [[https://valadoc.org/gtk4/Gtk.StringList.html|Gtk.StringList]] instead,
 * it is not possible to give "active-id" to each row unlike Gtk.ComboBoxText. This class achieves that
 * using normal Gtk.DropDown, while hiding messy stuff and making it simple to use like Gtk.ComboBoxText.
 *
 * {{../doc/images/dropdowntext.png|An example DropDownText}}
 */
public sealed class Ryokucha.DropDownText : Gtk.Widget {
    /**
     * Emitted when the active item is changed.
     */
    public signal void changed ();

    /**
     * The value of the ID column of the active row.
     */
    public string? active_id { get; set; }

    /**
     * The desired maximum width of the label, in characters.
     *
     * If this property is set to -1, the width will be calculated automatically.
     */
    public int max_width_chars { get; set; }

    /**
     * The preferred place to ellipsize the string, if the label does not have enough room to display the entire string.
     *
     * If this property is set to {@link Pango.EllipsizeMode.NONE}, no tooltip text is se for each row.
     * Otherwise, tooltip text is set for each row from its label text.
     */
    public Pango.EllipsizeMode ellipsize { get; set; }

    /**
     * A {@link Gtk.DropDown} which this uses internally.
     */
    public Gtk.DropDown dropdown { get; set; }

    private class ListStoreItem : Object {
        public string id { get; construct; }
        public string text { get; construct; }

        public ListStoreItem (string? id, string text) {
            Object (
                id: id ?? (Random.next_int ().to_string ()),
                text: text
            );
        }

        static construct {
            Random.set_seed ((uint32) time_t (null));
        }
    }

    private class DropDownRow : Gtk.Widget {
        public Gtk.Label label { get; set; }

        public DropDownRow () {
        }

        ~DropDownRow () {
            get_first_child ().unparent ();
        }

        static construct {
            set_layout_manager_type (typeof (Gtk.BinLayout));
        }

        construct {
            label = new Gtk.Label (null) {
                halign = Gtk.Align.START
            };

            label.set_parent (this);
        }
    }

    private ListStore liststore;

    /**
     * Creates a new {@link Ryokucha.DropDownText}.
     * @return A new {@link Ryokucha.DropDownText}
     */
    public DropDownText () {
    }

    ~DropDownText () {
        get_first_child ().unparent ();
    }

    static construct {
        set_layout_manager_type (typeof (Gtk.BinLayout));
    }

    construct {
        liststore = new ListStore (typeof (ListStoreItem));

        var factory = new Gtk.SignalListItemFactory ();
        factory.setup.connect ((obj) => {
            var list_item = obj as Gtk.ListItem;

            var row = new DropDownRow ();
            list_item.child = row;
        });
        factory.bind.connect ((obj) => {
            var list_item = obj as Gtk.ListItem;
            var item = list_item.item as ListStoreItem;
            var row = list_item.child as DropDownRow;
            Gtk.Label label = row.label;

            label.label = item.text;
            bind_property ("max-width-chars", label, "max-width-chars", BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE);
            bind_property ("ellipsize", label, "ellipsize", BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE);
            bind_property ("ellipsize", label, "tooltip_text", BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE,
                           (binding, from_value, ref to_value) => {
                               Pango.EllipsizeMode ellipsize_mode = (Pango.EllipsizeMode) from_value;
                               // Set the label text to tooltip_text if ellipsized, otherwise clear it
                               if (ellipsize_mode != Pango.EllipsizeMode.NONE) {
                                   to_value.set_string (label.label);
                               } else {
                                   to_value.set_string (null);
                               }

                               return true;
                           });
        });

        dropdown = new Gtk.DropDown (liststore, null) {
            factory = factory
        };

        dropdown.set_parent (this);

        dropdown.bind_property ("selected", this, "active-id",
                                BindingFlags.BIDIRECTIONAL,
                                (binding, from_value, ref to_value) => {
                                    var pos = (uint) from_value;
                                    // No item is selected
                                    if (pos == Gtk.INVALID_LIST_POSITION) {
                                        to_value.set_string (null);
                                        return false;
                                    }

                                    var item = (ListStoreItem) liststore.get_item (pos);
                                    to_value.set_string (item.id);
                                    return true;
                                },
                                (binding, from_value, ref to_value) => {
                                    uint pos;
                                    var id = (string) from_value;
                                    liststore.find_with_equal_func (
                                        // Find with id
                                        new ListStoreItem (id, ""),
                                        (a, b) => {
                                            return (((ListStoreItem) a).id == ((ListStoreItem) b).id);
                                        },
                                        out pos
                                    );
                                    to_value.set_uint (pos);
                                    return true;
                                }
        );

        notify["active-id"].connect (() => { changed (); });
    }

    /**
     * Appends text to the list of strings stored in this.
     *
     * If id is non-null then it is used as the ID of the row.<<BR>>
     * This is the same as calling {@link Ryokucha.DropDownText.insert} with a position of -1.
     *
     * @param id        A string ID for this value
     * @param text      A string
     */
    public void append (string? id, string text) {
        insert (-1, id, text);
    }

    /**
     * Appends text to the list of strings stored in this.
     *
     * This is the same as calling {@link Ryokucha.DropDownText.insert_text} with a position of -1.
     *
     * @param text      A string
     */
    public void append_text (string text) {
        insert_text (-1, text);
    }

    /**
     * Returns the currently active string in this.
     *
     * If no row is currently selected, null is returned. If this contains an entry, this function will return its contents (which will not necessarily be an item from the list).
     *
     * @return          A newly allocated string containing the currently active text. Must be freed with g_free.
     */
    public string? get_active_text () {
        Object? selected_item = dropdown.selected_item;
        if (selected_item == null) {
            return null;
        }

        return ((ListStoreItem) selected_item).text;
    }

    /**
     * Inserts text at position in the list of strings stored in this.
     *
     * If id is non-null then it is used as the ID of the row.<<BR>>
     * If position is negative then text is appended.
     *
     * @param position  An index to insert text
     * @param id        A string ID for this value
     * @param text      A string to display
     */
    public void insert (int position, string? id, string text) {
        var item = new ListStoreItem (id, text);

        if (position < 0) {
            liststore.append (item);
        } else {
            liststore.insert (position, item);
        }
    }

    /**
     * Inserts text at position in the list of strings stored in this.
     *
     * If position is negative then text is appended.<<BR>>
     * This is the same as calling {@link Ryokucha.DropDownText.insert} with a null ID string.
     *
     * @param position  An index to insert text
     * @param text      A string
     */
    public void insert_text (int position, string text) {
        insert (position, null, text);
    }

    /**
     * Prepends text to the list of strings stored in this.
     *
     * This is the same as calling {@link Ryokucha.DropDownText.insert} with a position of 0.
     *
     * @param id        A string ID for this value
     * @param text      A string
     */
    public void prepend (string? id, string text) {
        insert (0, id, text);
    }

    /**
     * Prepends text to the list of strings stored in this.
     *
     * This is the same as calling {@link Ryokucha.DropDownText.insert_text} with a position of 0.
     *
     * @param text      A string
     */
    public void prepend_text (string text) {
        insert_text (0, text);
    }

    /**
     * Removes the string at position from this.
     *
     * @param position  Index of the item to remove
     */
    public void remove (int position) {
        liststore.remove (position);
    }

    /**
     * Removes all the text entries from the dropdown.
     */
    public void remove_all () {
        liststore.remove_all ();
    }
}
