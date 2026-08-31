@extends('admin.layouts.app')

@section('content')
<div style="margin-bottom: 16px;">
    <a href="{{ route('admin.users') }}" style="color:var(--blue); font-weight:600; display:inline-flex; align-items:center; gap:6px;">
        &larr; Back to All Users
    </a>
</div>

<div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));">
    <div class="stat-card">
        <h3>User Profile</h3>
        <div style="font-size: 18px; font-weight: 700; color: var(--text); margin: 6px 0;">
            {{ $user->name ?: 'User #' . $user->id }}
        </div>
        <div style="color: var(--muted); font-size: 13px;">{{ $user->email }}</div>
        <div class="hint" style="margin-top: 8px;">Joined: {{ $user->created_at ? $user->created_at->format('d M Y, h:i A') : '—' }}</div>
    </div>

    <div class="stat-card">
        <h3>Plan & Card Capacity</h3>
        <div style="display:flex; align-items:center; gap:8px; margin: 6px 0;">
            @if ($user->isPremiumActive())
                <span class="badge badge-green" style="font-size:13px; padding:4px 10px;">{{ strtoupper($user->premium_plan ?? 'PREMIUM') }} (ACTIVE)</span>
            @else
                <span class="badge badge-gray" style="font-size:13px; padding:4px 10px;">FREE PLAN</span>
            @endif
        </div>
        <div style="font-size:12px; color:var(--muted); line-height:1.5;">
            <div>Saved Cards: <strong>{{ $user->savedCards()->count() }}</strong> / <strong>{{ number_format($user->getSaveLimit()) }}</strong> limit</div>
            <div style="color:var(--blue); font-weight:600;">Remaining Capacity: {{ number_format($user->getRemainingCardCapacity()) }} cards</div>
            <div>
                @if ($user->isPremiumActive())
                    Expires: <strong>{{ $user->premium_expires_at ? $user->premium_expires_at->format('d M Y') : 'Active' }}</strong>
                @elseif ($user->premium_expires_at)
                    Expired: <strong>{{ $user->premium_expires_at->format('d M Y') }}</strong>
                @else
                    Status: <strong>Free Tier</strong>
                @endif
            </div>
        </div>
        <div class="hint" style="margin-top: 6px;">Payment Status: {{ $user->getPaymentStatus() }}</div>
    </div>

    <div class="stat-card">
        <h3>Product Orders</h3>
        <div class="value" style="color:var(--blue)">{{ $orders->count() }}</div>
        <div class="hint">Total Spent: ₹{{ number_format($totalSpent) }}</div>
    </div>
</div>

<div class="panel" style="margin-top: 20px;">
    <div class="panel-head">
        <h3>Orders Placed by {{ $user->name ?: 'this user' }}</h3>
        <span>{{ $orders->where('status', 'paid')->count() }} paid out of {{ $orders->count() }} orders</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>Order #</th>
                <th>Products / Items</th>
                <th>Qty</th>
                <th>Amount</th>
                <th>Razorpay Payment ID</th>
                <th>Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($orders as $order)
                <tr>
                    <td><strong>{{ $order->order_number }}</strong></td>
                    <td>
                        @php
                            $items = is_array($order->items) ? $order->items : json_decode($order->items, true) ?? [];
                        @endphp
                        @if (!empty($items))
                            @foreach ($items as $item)
                                <div style="font-size:12px;">
                                    <strong>{{ $item['product_name'] ?? 'Product' }}</strong>
                                    <span style="color:var(--muted)">({{ $item['quantity'] ?? 1 }}x @ ₹{{ $item['unit_price'] ?? 0 }})</span>
                                    @if (!empty($item['design_title']))
                                        <span style="color:var(--muted)">— {{ $item['design_title'] }}</span>
                                    @endif
                                </div>
                            @endforeach
                        @else
                            <span style="color:var(--muted)">ID CARDS</span>
                        @endif
                    </td>
                    <td>{{ $order->total_qty }}</td>
                    <td><strong>₹{{ number_format($order->subtotal) }}</strong></td>
                    <td>
                        <span style="font-family:monospace; font-size:11px; color:var(--muted)">
                            {{ $order->razorpay_payment_id ?? 'Pending' }}
                        </span>
                    </td>
                    <td>{{ $order->created_at ? $order->created_at->format('d M Y, h:i A') : '—' }}</td>
                    <td>
                        @php
                            $badge = match ($order->status) {
                                'paid' => 'badge-green',
                                'delivered' => 'badge-green',
                                'created' => 'badge-orange',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ ucfirst($order->status) }}</span>
                    </td>
                    <td>
                        <a href="{{ route('admin.orders.show', $order->id) }}" style="color:var(--blue); font-weight:600; font-size:12px;">
                            View Receipt &rarr;
                        </a>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="8" style="text-align:center; padding: 24px; color:var(--muted)">
                        This user has not placed any product orders yet.
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>

@if ($savedCards->isNotEmpty())
<div class="panel" style="margin-top: 24px;">
    <div class="panel-head">
        <div>
            <h3 style="margin:0;">Saved Cards & Original Created Templates</h3>
            <span style="font-size:12px; color:var(--muted);">All {{ $savedCards->count() }} templates designed by this user (Front & Back HD)</span>
        </div>
        <span class="badge badge-blue">{{ $savedCards->count() }} Templates</span>
    </div>

    <div style="padding: 20px; display:grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px;">
        @foreach ($savedCards as $card)
            @php
                $frontUrl = $card->front_path ? (str_starts_with($card->front_path, 'http') ? $card->front_path : asset($card->front_path)) : null;
                $backUrl = $card->back_path ? (str_starts_with($card->back_path, 'http') ? $card->back_path : asset($card->back_path)) : null;
            @endphp
            <div style="background: #ffffff; border: 1px solid var(--border); border-radius: 12px; overflow:hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.04); display:flex; flex-direction:column;">
                <div style="background: #1e293b; color: #ffffff; padding: 10px 14px; display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <div style="font-size:13px; font-weight:700;">{{ $card->student_name ?: $card->title }}</div>
                        <div style="font-size:11px; opacity:0.8;">{{ $card->institute_name ?: 'Institution' }}</div>
                    </div>
                    <span style="background:rgba(255,255,255,0.15); font-size:10px; padding:2px 8px; border-radius:12px;">
                        {{ $card->template_name }}
                    </span>
                </div>

                <div style="padding: 12px; background:#f8fafc; flex:1;">
                    <div style="display:grid; grid-template-columns: {{ $backUrl ? '1fr 1fr' : '1fr' }}; gap: 8px;">
                        @if ($frontUrl)
                            <div style="text-align:center;">
                                <div style="font-size:10px; font-weight:700; color:var(--blue); margin-bottom:4px;">FRONT</div>
                                <a href="{{ $frontUrl }}" target="_blank">
                                    <img src="{{ $frontUrl }}" alt="Front" style="width:100%; max-height:160px; object-fit:contain; border-radius:6px; border:1px solid #e2e8f0; background:#fff;" />
                                </a>
                            </div>
                        @endif
                        @if ($backUrl)
                            <div style="text-align:center;">
                                <div style="font-size:10px; font-weight:700; color:var(--green); margin-bottom:4px;">BACK</div>
                                <a href="{{ $backUrl }}" target="_blank">
                                    <img src="{{ $backUrl }}" alt="Back" style="width:100%; max-height:160px; object-fit:contain; border-radius:6px; border:1px solid #e2e8f0; background:#fff;" />
                                </a>
                            </div>
                        @endif
                    </div>
                </div>

                <div style="padding: 8px 14px; background:#ffffff; border-top:1px solid var(--border); font-size:11px; color:var(--muted); display:flex; justify-content:space-between;">
                    <span>Service: <strong>{{ $card->service }}</strong></span>
                    <span>{{ $card->created_at ? $card->created_at->format('d M Y') : '—' }}</span>
                </div>
            </div>
        @endforeach
    </div>
</div>
@endif

@endsection
